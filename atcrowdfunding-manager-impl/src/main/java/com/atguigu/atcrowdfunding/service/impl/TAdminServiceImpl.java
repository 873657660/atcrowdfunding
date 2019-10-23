package com.atguigu.atcrowdfunding.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TAdminExample;
import com.atguigu.atcrowdfunding.bean.TAdminExample.Criteria;
import com.atguigu.atcrowdfunding.exception.LoginRegistException;
import com.atguigu.atcrowdfunding.mapper.TAdminMapper;
import com.atguigu.atcrowdfunding.service.TAdminService;
import com.atguigu.atcrowdfunding.util.AppDateUtils;
import com.atguigu.atcrowdfunding.util.Const;
import com.atguigu.atcrowdfunding.util.MD5Util;
import com.github.pagehelper.PageInfo;

@Service
public class TAdminServiceImpl implements TAdminService {

	@Autowired
	TAdminMapper adminMapper;

	@Override
	public TAdmin getAdminByLogin(String loginacct, String userpswd) {

		TAdminExample example = new TAdminExample(); //用于表示查询条件
		
		example.createCriteria().andLoginacctEqualTo(loginacct);
		
		List<TAdmin> list = adminMapper.selectByExample(example);
		
		if(list.size()==0) {
			throw new LoginRegistException(Const.LOGIN_LOGINACCT_ERROR);
		}
		
		TAdmin admin = list.get(0);
		
		String newPassword = MD5Util.digest(userpswd);
		
		if(!admin.getUserpswd().equals(newPassword)) {
			throw new LoginRegistException(Const.LOGIN_USERPSWD_ERROR);
		}
		
		return admin;
	}

	@Override
	public PageInfo<TAdmin> listAdminPage(Map<String, Object> paramMap) {
		
		TAdminExample example = new TAdminExample();
		
		String condition = (String)paramMap.get("condition");
		
		if(!"".equals(condition)) {
			example.createCriteria().andLoginacctLike("%"+condition+"%");
			
			Criteria criteria2 = example.createCriteria();
			criteria2.andUsernameLike("%"+condition+"%");
			
			Criteria criteria3 = example.createCriteria();
			criteria3.andEmailLike("%"+condition+"%");
			
			example.or(criteria2);
			example.or(criteria3);
		}
		
		//example.setOrderByClause("createtime desc"); //  asc 升序    desc 降序
		
		List<TAdmin> list = adminMapper.selectByExample(example); //开启分页功能，只查当前页
		
		PageInfo<TAdmin> page = new PageInfo<TAdmin>(list,5);
		
		return page;
	}

	@Override
	public void saveTAdmin(TAdmin admin) {
		admin.setCreatetime(AppDateUtils.getFormatTime());
		admin.setUserpswd(MD5Util.digest(Const.DEFAULT_USERPSWD));
		
		// insert into t_admin(loginacct,username,email,userpswd,createtime) values(?,?,?,?,?);
		//adminMapper.insert(admin);//所有字段都参与insert语句
		// insert into t_admin(loginacct,username,email) values(?,?,?);
		adminMapper.insertSelective(admin);//有选择性保存。动态SQL。  好处：为null属性，不参与insert语句。
	}

	@Override
	public TAdmin getTAdminById(Integer adminId) {
		return adminMapper.selectByPrimaryKey(adminId);
	}

	@Override
	public void updateTAdmin(TAdmin admin) {
		adminMapper.updateByPrimaryKeySelective(admin);
	}

	@Override
	public void deleteTAdmin(Integer id) {
		adminMapper.deleteByPrimaryKey(id);
	}

	@Override
	public void deleteBatchTAdmin(String ids) {
		List<Integer> idList = new ArrayList<Integer>();
		
		String[] strings = ids.split(",");
		for (String idStr : strings) {
			idList.add(Integer.parseInt(idStr));
		}
		
		TAdminExample example = new TAdminExample();
		example.createCriteria().andIdIn(idList);
		
		adminMapper.deleteByExample(example);
	}
	
}
