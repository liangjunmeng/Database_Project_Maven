package com.xxxx.util;

public class StringUtil {
    public static boolean isEmpty(String str){
        if(str == null || "".equals(str.trim())){
            return true;
        }
        return false;
    }
    //给字符串添加百分号
    public static String addPercentSign(String str){
        // 检查输入字符串是否为空
        if (str == null || str.isEmpty()) {
            return "%";
        }

        StringBuilder modifiedString = new StringBuilder();

        // 在字符串最前面添加百分号
        modifiedString.append("%");

        // 遍历字符串中的每个字符
        for (int i = 0; i < str.length(); i++) {
            modifiedString.append(str.charAt(i));  // 添加字符
            if (i != str.length() - 1) {
                modifiedString.append("%");  // 每个字符后添加百分号，除了最后一个字符
            }
        }

        // 在字符串末尾添加百分号
        modifiedString.append("%");

        return modifiedString.toString();
    }
}
