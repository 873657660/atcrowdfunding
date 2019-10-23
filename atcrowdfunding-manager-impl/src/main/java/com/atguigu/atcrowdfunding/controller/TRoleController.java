package com.atguigu.atcrowdfunding.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.service.TRoleService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Controller
public class TRoleController {

	@Autowired
	TRoleService roleService ;
	
	
	@ResponseBody
	@RequestMapping("/role/listPermissionIdByRoleId")
	public List<Integer> listPermissionIdByRoleId(Integer roleId) {		
		return roleService.listPermissionIdByRoleId(roleId);
	}
	
	@ResponseBody
	@RequestMapping("/role/doAssignPermissionToRole")
	public String doAssignPermissionToRole(Integer roleId,Integer[] id) {
		roleService.doAssignPermissionToRole(roleId,id);
		return "ok";
	}
	
	@ResponseBody
	@RequestMapping("/role/delete")
	public String delete(Integer roleId) {
		roleService.deleteRoleById(roleId);
		return "ok";
	}
	
	@ResponseBody
	@RequestMapping("/role/update")
	public String update(TRole role) {
		roleService.updateRole(role);
		return "ok";
	}
	
	
	@ResponseBody
	@RequestMapping("/role/get")
	public TRole get(Integer roleId) {
		TRole role = roleService.getRoleById(roleId);
		return role;
	}
	
	
	@ResponseBody
	@RequestMapping("/role/save")
	public String save(TRole role) {
		roleService.saveRole(role);
		return "ok";
	}
	
	
	
	@RequestMapping("/role/index")
	public String index() {
		return "role/index";
	}
	
	
	
	/**
	 * 
	 * 	如果返回结果为String类型：采用StringHttpMessageConverter转换器返回结果。
	 * 		直接将字符串以流的形式返回给客户端浏览器。
	 * 
	 * 	如果返回结果为复杂对象类型（实体类，VO类，List,Map等）：采用MappingJackson2HttpMessageConverter转换器返回结果
	 * 		将复杂对象转换为json数据格式，以流的形式返回给浏览器。利用Jackson组件进行转换。SpringMVC框架默认集成Jackson
	 * 
	 */
	@ResponseBody
	@RequestMapping("/role/loadData")
	public PageInfo<TRole> loadData(
						@RequestParam(value="pageNum",required = false,defaultValue = "1")  Integer pageNum,
						@RequestParam(value="pageSize",required = false,defaultValue = "2") Integer pageSize,
						@RequestParam(value="condition",required = false,defaultValue = "") String condition) {
		
		PageHelper.startPage(pageNum, pageSize);
		
		Map<String,Object> paramMap = new HashMap<String,Object>();
		paramMap.put("condition", condition);
		
		PageInfo<TRole> page = roleService.listRolePage(paramMap) ;
		
		return page; // 转换为json串
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
