package com.atguigu.atcrowdfunding.service;

import java.util.List;
import java.util.Map;

import com.atguigu.atcrowdfunding.bean.TRole;
import com.github.pagehelper.PageInfo;

public interface TRoleService {

	PageInfo<TRole> listRolePage(Map<String, Object> paramMap);

	void saveRole(TRole role);

	TRole getRoleById(Integer roleId);

	void updateRole(TRole role);

	void deleteRoleById(Integer roleId);

	List<TRole> listAllRole();

	List<Integer> listRoleIdByAdminId(Integer adminId);

	void saveAdminAndRoleRelationship(Integer adminId, Integer[] id);

	void deleteAdminAndRoleRelationship(Integer adminId, Integer[] id);

	void doAssignPermissionToRole(Integer roleId, Integer[] permissionIds);

	List<Integer> listPermissionIdByRoleId(Integer roleId);

}
