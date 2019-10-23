package com.atguigu.atcrowdfunding.listener;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.atguigu.atcrowdfunding.util.Const;


//ServletContextListener 在服务器启动和停止时进行监听事件。来做业务扩展。
public class SystemStartupInitListener implements ServletContextListener {

	Logger log = LoggerFactory.getLogger(SystemStartupInitListener.class);
	
	//在服务器启动时，确切在application对象被创建时，执行初始化操作
	@Override
	public void contextInitialized(ServletContextEvent sce) {
		ServletContext application = sce.getServletContext();
		String contextPath = application.getContextPath();
		application.setAttribute(Const.PATH, contextPath);
		log.debug("**********************将上下文的值存放到 application中：{}**********************",contextPath);
	}

	//在服务器停止时，或项目卸载时。执行销毁操作
	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		ServletContext application = sce.getServletContext();
		application.removeAttribute(Const.PATH);
		log.debug("**********************application销毁**********************");
	}

}
