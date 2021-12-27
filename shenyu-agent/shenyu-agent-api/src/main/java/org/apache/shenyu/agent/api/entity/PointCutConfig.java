package org.apache.shenyu.agent.api.entity;

import java.util.List;
import java.util.Map;

/**
 * The type Point cut config.
 */
public final class PointCutConfig {
    
    private List<PointCut> pointCuts;
    
    /**
     * Gets point cuts.
     *
     * @return the point cuts
     */
    public List<PointCut> getPointCuts() {
        return pointCuts;
    }
    
    /**
     * Sets point cuts.
     *
     * @param pointCuts the point cuts
     */
    public void setPointCuts(final List<PointCut> pointCuts) {
        this.pointCuts = pointCuts;
    }
    
    /**
     * The type Point cut.
     */
    public static final class PointCut {
        
        private String targetClass;
    
        private List<Point> points;
    
        private Map<String, Handler> handlers;
    
        /**
         * Gets target class.
         *
         * @return the target class
         */
        public String getTargetClass() {
            return targetClass;
        }
    
        /**
         * Sets target class.
         *
         * @param targetClass the target class
         */
        public void setTargetClass(final String targetClass) {
            this.targetClass = targetClass;
        }
    
        /**
         * Gets points.
         *
         * @return the point cuts
         */
        public List<Point> getPoints() {
            return points;
        }
    
        /**
         * Sets points.
         *
         * @param points the points
         */
        public void setPoints(final List<Point> points) {
            this.points = points;
        }
    
        /**
         * Gets handlers.
         *
         * @return the handlers
         */
        public Map<String, Handler> getHandlers() {
            return handlers;
        }
    
        /**
         * Sets handlers.
         *
         * @param handlers the handlers
         */
        public void setHandlers(final Map<String, Handler> handlers) {
            this.handlers = handlers;
        }
    }
    
    /**
     * The type Point.
     */
    public static final class Point {
        
        private String type;
        
        private String name;
    
        /**
         * Gets type.
         *
         * @return the type
         */
        public String getType() {
            return type;
        }
    
        /**
         * Sets type.
         *
         * @param type the type
         */
        public void setType(final String type) {
            this.type = type;
        }
    
        /**
         * Gets name.
         *
         * @return the name
         */
        public String getName() {
            return name;
        }
    
        /**
         * Sets name.
         *
         * @param name the name
         */
        public void setName(final String name) {
            this.name = name;
        }
    }
    
    /**
     * The type Handler.
     */
    public static final class Handler {
        
        private List<String> names;
    
        /**
         * Gets names.
         *
         * @return the names
         */
        public List<String> getNames() {
            return names;
        }
    
        /**
         * Sets names.
         *
         * @param names the names
         */
        public void setNames(final List<String> names) {
            this.names = names;
        }
    }
}
