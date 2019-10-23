package com.atguigu.atcrowdfunding.service;

import java.util.Map;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.github.pagehelper.PageInfo;

public interface TAdminService {

	TAdmin getAdminByLogin(String loginacct, String userpswd);

	PageInfo<TAdmin> listAdminPage(Map<String, Object> paramMap);

	void saveTAdmin(TAdmin admin);

	TAdmin getTAdminById(Integer adminId);

	void updateTAdmin(TAdmin admin);

	void deleteTAdmin(Integer id);

	void deleteBatchTAdmin(String ids);

}
