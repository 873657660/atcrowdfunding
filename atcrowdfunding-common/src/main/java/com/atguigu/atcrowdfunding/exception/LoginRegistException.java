package com.atguigu.atcrowdfunding.exception;


//为什么继承RuntimeException，而不是Exception.因为，声明式事务遇到运行期异常自动回滚。
public class LoginRegistException extends RuntimeException {

	public LoginRegistException(){
		this("登录注册异常");
	}
	
	public LoginRegistException(String message) {
		super(message);
	}
}
