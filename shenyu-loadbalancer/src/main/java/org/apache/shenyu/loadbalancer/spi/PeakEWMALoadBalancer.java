/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.shenyu.loadbalancer.spi;

import org.apache.shenyu.loadbalancer.entity.Upstream;
import org.apache.shenyu.spi.Join;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ThreadLocalRandom;
import java.util.concurrent.locks.ReentrantLock;

/**
 * <p>
 * PeakEwmaLoadBalance is designed to converge quickly when encountering slow endpoints.
 * It is quick to react to latency spikes recovering only cautiously.Peak EWMA takes
 * history into account,so that slow behavior is penalized relative to the
 * supplied `decayTime`.
 * if there are multiple invokers and the same cost,then randomly called,which doesn't care
 * about weight.
 * <p>
 * Inspiration drawn from:
 * https://github.com/twitter/finagle/blob/1bc837c4feafc0096e43c0e98516a8e1c50c4421
 * /finagle-core/src/main/scala/com/twitter/finagle/loadbalancer/PeakEwma.scala
 *
 * https://github.com/apache/dubbo-spi-extensions/blob/efd18a63468f817a7581fea44e9e2e3f35d9c9ba
 * /dubbo-cluster-extensions/dubbo-cluster-loadbalance-peakewma/src/main/java/org/apache
 * /dubbo/rpc/cluster/loadbalance/PeakEwmaLoadBalance.java#L46
 */
@Join
public class PeakEWMALoadBalancer extends AbstractLoadBalancer {

    private static final double PENALTY = Long.MAX_VALUE >> 16;

    private static final double ZERO_COST = 1E-6;

    private static final double DECAY_TIME = 600;

    private Map<Upstream, Metric> upstreamMetricMap = new ConcurrentHashMap<>();

    @Override
    protected Upstream doSelect(List<Upstream> upstreamList, String ip) {
        double minResponse = Double.MAX_VALUE;

        List<Integer> selectInvokerIndexList = new ArrayList<>(upstreamList.size());
        Metric metric;
        for (int i = 0; i < upstreamList.size(); i++) {
            if (upstreamMetricMap.containsKey(upstreamList.get(i))) {
                metric = upstreamMetricMap.get(upstreamList.get(i));
            } else {
                metric = new Metric(upstreamList.get(i));
                upstreamMetricMap.put(upstreamList.get(i), metric);
            }
            double estimateResponse = metric.getCost();

            if (estimateResponse < minResponse) {
                selectInvokerIndexList.clear();
                selectInvokerIndexList.add(i);
                minResponse = estimateResponse;
            } else if (estimateResponse == minResponse) {
                selectInvokerIndexList.add(i);
            }
        }

        return upstreamList.get(selectInvokerIndexList.get(ThreadLocalRandom.current().nextInt(selectInvokerIndexList.size())));
    }

    protected static class Metric {

        /**
         *  last timestamp in Millis we observed an runningTime
         */
        private volatile long lastUpdateTime;

        /**
         * ewma of rtt, sensitive to peaks.
         */
        private volatile double cost;

        private Upstream upstream;

        //lock for get and set cost
        ReentrantLock ewmaLock = new ReentrantLock();

        public Metric(Upstream upstream) {
            this.upstream = upstream;
            this.lastUpdateTime = System.currentTimeMillis();
            this.cost = 0.0;
        }

        private void observe() {
            double rtt = 0;

            rtt = Math.max(this.upstream.getResponseStamp() - this.upstream.getLastPicked(), rtt);

            final long currentTime = System.currentTimeMillis();
            long td = Math.max(currentTime - lastUpdateTime, 0);
            double w = Math.exp(-td / DECAY_TIME);
            if (rtt > cost) {
                cost = rtt;
            } else {
                cost = cost * w + rtt * (1.0 - w);
            }

            lastUpdateTime = currentTime;


        }

        private double getCost() {
            ewmaLock.lock();
            observe();
            int active = 0;
            if (upstream.isHealthy()) {
                active = 1;
            }

            ewmaLock.unlock();

            double costTemp = cost;

            //If we don't have any latency history, we penalize the host on the first probe.
            return (costTemp < ZERO_COST && active != 0) ? PENALTY + active : costTemp * (active + 1);
        }

    }

}
