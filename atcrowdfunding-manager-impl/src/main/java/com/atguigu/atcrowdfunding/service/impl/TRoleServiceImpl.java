package com.atguigu.atcrowdfunding.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.bean.TRoleExample;
import com.atguigu.atcrowdfunding.bean.TRolePermissionExample;
import com.atguigu.atcrowdfunding.mapper.TAdminRoleMapper;
import com.atguigu.atcrowdfunding.mapper.TRoleMapper;
import com.atguigu.atcrowdfunding.mapper.TRolePermissionMapper;
import com.atguigu.atcrowdfunding.service.TRoleService;
import com.github.pagehelper.PageInfo;

@Service
public class TRoleServiceImpl implements TRoleService {

	@Autowired
	TRoleMapper roleMapper;
	
	@Autowired
	TAdminRoleMapper adminRoleMapper;
	
	@Autowired
	TRolePermissionMapper rolePermissionMapper;

	@Override
	public PageInfo<TRole> listRolePage(Map<String, Object> paramMap) {
		
		TRoleExample example = new TRoleExample();
		
		String condition = (String)paramMap.get("condition");
		if(!StringUtils.isEmpty(condition)) {
			example.createCriteria().andNameLike("%"+condition+"%");
		}
		
		List<TRole> list = roleMapper.selectByExample(example);
		
		PageInfo<TRole> page = new PageInfo<TRole>(list,5);
		return page;
	}

	@Override
	public void saveRole(TRole role) {
		roleMapper.insertSelective(role);
	}

	@Override
	public TRole getRoleById(Integer roleId) {
		return roleMapper.selectByPrimaryKey(roleId);
	}

	@Override
	public void updateRole(TRole role) {
		roleMapper.updateByPrimaryKeySelective(role);
	}

	@Override
	public void deleteRoleById(Integer roleId) {
		roleMapper.deleteByPrimaryKey(roleId);
	}

	@Override
	public List<TRole> listAllRole() {
		return roleMapper.selectByExample(null);
	}

	@Override
	public List<Integer> listRoleIdByAdminId(Integer adminId) {
		return roleMapper.listRoleIdByAdminId(adminId);
	}

	@Override
	public void saveAdminAndRoleRelationship(Integer adminId, Integer[] id) {
		adminRoleMapper.saveAdminAndRoleRelationship(adminId,id);
	}

	@Override
	public void deleteAdminAndRoleRelationship(Integer adminId, Integer[] id) {
		adminRoleMapper.deleteAdminAndRoleRelationship(adminId,id);
	}

	@Override
	public void doAssignPermissionToRole(Integer roleId, Integer[] permissionIds) {
		//删除之前所分配的所有权限，重新增加新的分配。否则：需要考虑哪些是新增的，哪些是去掉，哪些不动的。
		TRolePermissionExample example = new TRolePermissionExample();
		example.createCriteria().andRoleidEqualTo(roleId);
		rolePermissionMapper.deleteByExample(example);
		rolePermissionMapper.doAssignPermissionToRole(roleId,permissionIds);
	}

	@Override
	public List<Integer> listPermissionIdByRoleId(Integer roleId) {
		return rolePermissionMapper.listPermissionIdByRoleId(roleId);
	}
	
}
