package com.atguigu.atcrowdfunding.service;

import java.util.List;

import com.atguigu.atcrowdfunding.bean.TMenu;

public interface TMenuService {

	List<TMenu> listMenuParent();

	List<TMenu> listAll();

	void saveMenu(TMenu menu);

	TMenu getMenu(Integer id);

	void updateMenu(TMenu menu);

	void deleteMenuById(Integer id);

}
