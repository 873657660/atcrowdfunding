package com.atguigu.atcrowdfunding.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.service.TAdminService;
import com.atguigu.atcrowdfunding.service.TRoleService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Controller
public class TAdminController {

	@Autowired
	TAdminService adminService ;
	
	@Autowired
	TRoleService roleService ;
	
	@ResponseBody
	@RequestMapping("/admin/doAssignRoleToAdmin")
	public String doAssignRoleToAdmin(Integer adminId,Integer[] id) {
		roleService.saveAdminAndRoleRelationship(adminId,id);
		return "ok";
	}
	
	@ResponseBody
	@RequestMapping("/admin/doUnAssignRoleToAdmin")
	public String doUnAssignRoleToAdmin(Integer adminId,Integer[] id) {
		roleService.deleteAdminAndRoleRelationship(adminId,id);
		return "ok";
	}
	
	@RequestMapping("/admin/toAssign")
	public String toAssign(Integer adminId,Model model) {
		
		//1.查询所有角色
		List<TRole> allRoleList =  roleService.listAllRole();
		
		
		//2.根据用户查询已经拥有的角色id
		List<Integer> selfRoleIdList =  roleService.listRoleIdByAdminId(adminId);
		
		List<TRole> assignRoleList = new ArrayList<TRole>(); //已分配
		List<TRole> unAssignRoleList = new ArrayList<TRole>(); //未分配
		
		model.addAttribute("assignRoleList", assignRoleList);
		model.addAttribute("unAssignRoleList", unAssignRoleList);
		
		for (TRole role : allRoleList) {
			if(selfRoleIdList.contains(role.getId())) {  //已分配
				//3.已分配角色集合
				assignRoleList.add(role);
			}else {//未分配
				//4.未分配角色集合
				unAssignRoleList.add(role);
			}
		}

		return "admin/assignRole"; 
	}
	
	@RequestMapping("/admin/doDeleteBatch")
	public String doDeleteBatch(String ids,Integer pageNum) {
		
		adminService.deleteBatchTAdmin(ids);
		
		return "redirect:/admin/index?pageNum="+pageNum; 
	}
	
	
	@RequestMapping("/admin/doDelete")
	public String doDelete(Integer id,Integer pageNum) {
		
		adminService.deleteTAdmin(id);
		
		return "redirect:/admin/index?pageNum="+pageNum; 
	}
	
	
	@RequestMapping("/admin/doUpdate")
	public String doUpdate(TAdmin admin,Integer pageNum) {
		
		adminService.updateTAdmin(admin);
		
		return "redirect:/admin/index?pageNum="+pageNum; 
	}
	
	
	@RequestMapping("/admin/toUpdate")
	public String toUpdate(@RequestParam("id") Integer adminId,Model model) {
		
		TAdmin admin = adminService.getTAdminById(adminId);
		model.addAttribute("admin", admin);
		
		return "admin/update";
	}
	
	
	
	@RequestMapping("/admin/toAdd")
	public String toAdd() {
		return "admin/add";
	}
	
	
	@RequestMapping("/admin/doAdd")
	public String doAdd(TAdmin admin) {
		
		adminService.saveTAdmin(admin);
		
		return "redirect:/admin/index?pageNum="+Integer.MAX_VALUE; // 分页合理化。指定非常大的页码，不存在，就会去到最后一页。
	}
	
	
	
	
	@RequestMapping("/admin/index")
	public String index(@RequestParam(value="pageNum",required = false,defaultValue = "1") Integer pageNum,
			@RequestParam(value="pageSize",required = false,defaultValue = "2") Integer pageSize,
			@RequestParam(value = "condition",required = false,defaultValue = "") String condition,
			Model model) {
		
		//在同一个线程中共享数据。
		PageHelper.startPage(pageNum, pageSize);  //将这个参数与当前线程进行绑定。通过ThreadLocal进行绑定线程。
		
		Map<String,Object> paramMap = new HashMap<String,Object>();
		//paramMap.put("pageNum", pageNum);
		//paramMap.put("pageSize", pageSize);
		paramMap.put("condition", condition);
		
		PageInfo<TAdmin> page = adminService.listAdminPage(paramMap);
		
		//在同一个请求中共享数据。
		model.addAttribute("page", page); //  Model   Map   =>>>  HttpServletRequest
		
		return "admin/index";
	}
}
