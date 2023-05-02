package org.apache.shenyu.common.enums;

/**
 * xss enum.
 */
public enum XssEnum {


    /**
     * Reject xss enum.
     */
    REJECT(0, "reject"),

    /**
     * Allow xss enum.
     */
    ALLOW(1, "allow");

    private final int code;

    private final String name;

    /**
     * all args constructor.
     *
     * @param code code
     * @param name name
     */
    XssEnum(final int code, final String name) {
        this.code = code;
        this.name = name;
    }

    /**
     * get code.
     *
     * @return code
     */
    public int getCode() {
        return code;
    }

    /**
     * get name.
     *
     * @return name
     */
    public String getName() {
        return name;
    }
}
