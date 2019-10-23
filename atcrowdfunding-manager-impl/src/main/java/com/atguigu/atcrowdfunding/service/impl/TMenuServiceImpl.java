package com.atguigu.atcrowdfunding.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.mapper.TMenuMapper;
import com.atguigu.atcrowdfunding.service.TMenuService;

@Service
public class TMenuServiceImpl implements TMenuService {

	@Autowired
	TMenuMapper menuMapper ;

	@Override
	public List<TMenu> listMenuParent() {
		
		List<TMenu> allParentList = new ArrayList<TMenu>() ;
		Map<Integer,TMenu> allParentMap = new HashMap<Integer,TMenu>();
		
		List<TMenu> allList = menuMapper.selectByExample(null);
		
		for (TMenu menu : allList) {
			if(menu.getPid()==0) {
				allParentList.add(menu);
				allParentMap.put(menu.getId(), menu);
			}
		}
		
		
		for (TMenu menu : allList) {
			if(menu.getPid()!=0) {
				Integer pid = menu.getPid(); //根据子菜单查找父菜单
				
				TMenu parent = allParentMap.get(pid);
				parent.getChildren().add(menu); //通过父菜单组合子菜单。
			}
		}
		
		return allParentList;
	}

	@Override
	public List<TMenu> listAll() {
		return menuMapper.selectByExample(null);
	}

	@Override
	public void saveMenu(TMenu menu) {
		menuMapper.insert(menu);
	}

	@Override
	public TMenu getMenu(Integer id) {
		return menuMapper.selectByPrimaryKey(id);
	}

	@Override
	public void updateMenu(TMenu menu) {
		menuMapper.updateByPrimaryKeySelective(menu);
	}

	@Override
	public void deleteMenuById(Integer id) {
		menuMapper.deleteByPrimaryKey(id);
	}
	
}
