package com.atguigu.atcrowdfunding.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.exception.LoginRegistException;
import com.atguigu.atcrowdfunding.service.TAdminService;
import com.atguigu.atcrowdfunding.service.TMenuService;
import com.atguigu.atcrowdfunding.util.Const;

@Controller
public class DispatcherController {

	@Autowired
	TAdminService adminService;
	
	@Autowired
	TMenuService menuService ;
	
	Logger log = LoggerFactory.getLogger(DispatcherController.class);
	
	
	@RequestMapping("/index")
	public String index() {
		
		return "index";
	}
	
	//@RequestMapping(value="/toLogin",method = RequestMethod.GET)
//	@GetMapping("/toLogin")
//	@PostMapping("/toLogin")
//	@PutMapping("/toLogin")
//	@DeleteMapping("/toLogin")
	@RequestMapping("/toLogin")
	public String toLogin() {
		
		return "login";
	}
	
	
	@RequestMapping("/logout")
	public String logout(HttpSession session) {
		
		if(session!=null) {
			session.removeAttribute(Const.LOGIN_ADMIN);
			session.removeAttribute("allParent");
			session.invalidate();
		}
		
		return "redirect:/toLogin";
	}
	
	
	
	@RequestMapping("/main")
	public String main(HttpSession session) {
		log.debug("main...");
		
		List<TMenu> allParent = (List<TMenu>)session.getAttribute("allParent");
		
		if(allParent==null) {
			allParent =  menuService.listMenuParent();
			session.setAttribute("allParent", allParent);
		}
		
		log.debug("allParent={}",allParent);
		
		return "main";
	}
	
	
	@RequestMapping("/doLogin")
	public String doLogin(String loginacct,String userpswd,HttpSession session) {		
		log.debug("loginacct={}",loginacct); //日志跟踪
		log.debug("userpswd={}",userpswd);		
		/*
		 * if(StringUtils.isEmpty(loginacct)) { //后台数据校验
		 * 
		 * }
		 */
		
		try {
			TAdmin admin = adminService.getAdminByLogin(loginacct,userpswd);
			session.setAttribute(Const.LOGIN_ADMIN, admin);
			//return "main"; //不要进行转发，否则，会出现表单重复提交。也就是重复登录校验。
			return "redirect:/main"; //重定向可以避免重复登录校验。
		} catch (LoginRegistException e) {
			e.printStackTrace();			
			session.setAttribute(Const.MESSAGE, e.getMessage());				
			return "login";
		} catch(Exception e) {
			e.printStackTrace();			
			session.setAttribute(Const.MESSAGE, "登录失败");				
			return "login";
		} finally {
			//资源释放
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
