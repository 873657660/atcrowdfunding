package com.atguigu.atcrowdfunding.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@EnableWebSecurity
@Configuration //声明当前类是一个配置类。一个配置类就相当于一个XML配置文件。
public class AppWebSecurityConfig extends WebSecurityConfigurerAdapter {

	//<bean id="admin" class="com.atguigu.atcrowdfunding.bean.TAdmin"></bean>
	
//	@Bean
//	public TAdmin admin() {
//		return new TAdmin();
//	}
	
	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
		// 取消默认【认证】配置
		//super.configure(auth);
		
		//实验4。基于内存认证方式（了解）
		auth.inMemoryAuthentication()
		.withUser("zhangsan").password("123456").roles("ADMIN")
		.and()
		.withUser("lisi").password("123123").authorities("USER","MANAGER");

	}
	
	
	@Override
	protected void configure(HttpSecurity http) throws Exception {
		// 框架默认的【授权】配置。取消掉。否则，首页，静态资源都不能访问。
		//super.configure(http);
		
		//1.授权首页和静态资源(不要进行权限控制，任何人都可以访问)
		http.authorizeRequests()
			.antMatchers("/layui/**","/index.jsp").permitAll()
			.anyRequest().authenticated();
		
		
		//2.授权默认登录页(当发生403无权访问时，跳转登录页)
		//http.formLogin(); //开启默认登录页功能。
		
		http.formLogin().loginPage("/index.jsp")
				.usernameParameter("loginacct")
				.passwordParameter("userpswd")
				.loginProcessingUrl("/login") //去到自定义登录页
				.defaultSuccessUrl("/main.html");
		
		//禁用CSRF-防止跨站请求伪造
		http.csrf().disable();
	}
	
}
