package com.atguigu.atcrowdfunding.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.service.TMenuService;

@Controller
public class TMenuController {

	@Autowired
	TMenuService menuService ;
	
	
	@ResponseBody
	@RequestMapping("/menu/delete")
	public String delete(Integer id) {
		menuService.deleteMenuById(id);		
		return "ok";
	}
	
	@ResponseBody
	@RequestMapping("/menu/update")
	public String update(TMenu menu) {
		menuService.updateMenu(menu);		
		return "ok";
	}
	
	@ResponseBody
	@RequestMapping("/menu/get")
	public TMenu get(Integer id) {
		TMenu menu = menuService.getMenu(id);		
		return menu;
	}
	
	@RequestMapping("/menu/index")
	public String index() {		
		return "menu/index";
	}

	@ResponseBody
	@RequestMapping("/menu/save")
	public String save(TMenu menu) {
		menuService.saveMenu(menu);		
		return "ok";
	}
	
	@ResponseBody
	@RequestMapping("/menu/loadTree")
	public List<TMenu> loadTree() {
		List<TMenu> allMenuList =  menuService.listAll();		
		return allMenuList;
	}
	
}
