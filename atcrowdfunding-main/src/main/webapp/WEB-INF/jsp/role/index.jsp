<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

	<%@ include file="/WEB-INF/jsp/common/css.jsp" %>
	<style>
	.tree li {
        list-style-type: none;
		cursor:pointer;
	}
	table tbody tr:nth-child(odd){background:#F4F4F4;}
	table tbody td:nth-child(even){color:#C00;}
	</style>
  </head>

  <body>

    <jsp:include page="/WEB-INF/jsp/common/top.jsp"></jsp:include>

    <div class="container-fluid">
      <div class="row">
        <jsp:include page="/WEB-INF/jsp/common/menu.jsp"></jsp:include>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
			<div class="panel panel-default">
			  <div class="panel-heading">
				<h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
			  </div>
			  <div class="panel-body">
<form id="queryForm" class="form-inline" role="form" style="float:left;" >
  <div class="form-group has-feedback">
    <div class="input-group">
      <div class="input-group-addon">查询条件</div>
      <input class="form-control has-success" type="text" name="condition" value="${param.condition }" placeholder="请输入查询条件">
    </div>
  </div>
  <button id="queryBtn" type="button" class="btn btn-warning"><i class="glyphicon glyphicon-search"></i> 查询</button>
</form>
<button id="deleteBatchBtn" type="button" class="btn btn-danger" style="float:right;margin-left:10px;"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
<button id="addBtn" type="button" class="btn btn-primary" style="float:right;" ><i class="glyphicon glyphicon-plus"></i> 新增</button>
<br>
 <hr style="clear:both;">
          <div class="table-responsive">
            <table class="table  table-bordered">
              <thead>
                <tr>
                  <th width="30">#</th>
				  <th width="30"><input id="selectAllCheckbox" type="checkbox"></th>
                  <th>名称</th>
                  <th width="100">操作</th>
                </tr>
              </thead>
              <tbody>
	            
              </tbody>
			  <tfoot>
			     <tr >
				     <td colspan="6" align="center">
						<ul class="pagination"></ul>
					 </td>
				 </tr>

			  </tfoot>
            </table>
          </div>
			  </div>
			</div>
        </div>
      </div>
    </div>




<!-- 添加 -->
<div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">保存</h4>
      </div>
      <div class="modal-body">
      	<form id="addForm" role="form" >

		  <div class="form-group">
			<label>角色名称</label>
			<input type="text" class="form-control" name="name" placeholder="请输入角色名称">
		  </div>

		</form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button id="saveBtn" type="button" class="btn btn-primary">保存</button>
      </div>
    </div>
  </div>
</div>



<!-- 修改 -->
<div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">修改</h4>
      </div>
      <div class="modal-body">
      	<form id="updateForm" role="form" >

		  <div class="form-group">
			<label>角色名称</label>
			<input type="hidden" name="id">
			<input type="text" class="form-control" name="name" placeholder="请输入角色名称">
		  </div>

		</form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button id="updateBtn" type="button" class="btn btn-primary">修改</button>
      </div>
    </div>
  </div>
</div>





<!-- 给角色分配许可模态框 -->
<div class="modal fade" id="assignModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">给角色分配许可</h4>
      </div>
      <div class="modal-body">  
		<ul id="treeDemo" class="ztree"></ul>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button id="assignBtn" type="button" class="btn btn-primary">分配</button>
      </div>
    </div>
  </div>
</div>




    <%@ include file="/WEB-INF/jsp/common/js.jsp" %>
        <script type="text/javascript">
            $(function () {//页面加载完成的事件处理
			    $(".list-group-item").click(function(){
				    if ( $(this).find("ul") ) {
						$(this).toggleClass("tree-closed");
						if ( $(this).hasClass("tree-closed") ) {
							$("ul", this).hide("fast");
						} else {
							$("ul", this).show("fast");
						}
					}
				});
            
            	initData(1); //页面加载完成时，初始化第一页数据
            });

            var index = -1 ;
            
            var json = {
        			pageNum:1,
        			pageSize:2
        	};
            
            function initData(pageNum){
            	json.pageNum = pageNum ;
            	
            	$.ajax({            		
            		type:"post",
            		url:"${PATH}/role/loadData",
            		data:json,
            		beforeSend:function(){
            			index = layer.load(2,{time:10*1000});
            			//表单数据校验。
            			return true;
            		},
            		success:function(pageInfo){ //服务器端会将分页对象序列号为json串
            			
            			console.log(pageInfo);
            		
            			//初始化数据
            			initTable(pageInfo);
            			//初始化分页条
            			initNavg(pageInfo);
            		},
            		error:function(){
            			//异步请求出现错误，会执行该回调函数。
            		},
            		complete:function(){
            			//不管是否出现异常，都必须执行的操作。
            		}
            	});
            }	
            
          	//初始化数据
            function initTable(pageInfo){
            	var content = '';
            	
            	var list = pageInfo.list ;
            	
            	$.each(list,function(i,e){
            		content+='<tr>';
            		content+='  <td>'+(i+1)+'</td>';
            		content+='  <td><input type="checkbox"></td>';
            		content+='  <td>'+e.name+'</td>';
            		content+='  <td>';
            		content+='	  <button type="button" roleId="'+e.id+'" class="assignBtnClass btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>';
            		content+='	  <button type="button" roleId="'+e.id+'" class="updateBtnClass btn btn-primary btn-xs"><i class=" glyphicon glyphicon-pencil"></i></button>';
            		content+='	  <button type="button" roleId="'+e.id+'" class="deleteBtnClass btn btn-danger btn-xs"><i class=" glyphicon glyphicon-remove"></i></button>';
            		content+='  </td>';
            		content+='</tr>';
            	});
            	
            	$("tbody").html(content); // innerHtml
            	layer.close(index);
            }
            
          	//初始化分页条
			function initNavg(pageInfo){
            	var navg = '';
            	if(pageInfo.isFirstPage){
            		navg+='<li class="disabled"><a>上一页</a></li>';
            	}else{
            		navg+='<li><a onclick="initData('+(pageInfo.pageNum-1)+')">上一页</a></li>';
            	}
            	
            	for(var i=0;i<pageInfo.navigatepageNums.length;i++){
            		if(pageInfo.navigatepageNums[i] == pageInfo.pageNum){
            			navg+='<li class="active"><a onclick="initData('+pageInfo.navigatepageNums[i]+')">'+pageInfo.navigatepageNums[i]+'</a></li>';
            		}else{
            			navg+='<li><a onclick="initData('+pageInfo.navigatepageNums[i]+')">'+pageInfo.navigatepageNums[i]+'</a></li>';
            		}
            		
            	}
            	
            	
            	if(pageInfo.isLastPage){
            		navg+='<li class="disabled"><a>下一页</a></li>';
            	}else{
            		navg+='<li><a onclick="initData('+(pageInfo.pageNum+1)+')">下一页</a></li>';
            	}
            	$(".pagination").html(navg);
            }
            
            
            
            
            
            
            $("#queryBtn").click(function(){
            	var condition = $("#queryForm input[name='condition']").val();
            	
            	json.condition=condition ;
            	
            	initData(1);
            });
            
            
            
            
           //==========添加======================================================= 
           $("#addBtn").click(function(){
        	   $("#addModal").modal({
        		   show:true,
        		   backdrop:'static',
        		   keyboard:false
        	   });
           });
            
           $("#saveBtn").click(function(){
        	   var name = $("#addModal input[name='name']").val();
        	   $.ajax({
        		   type:'post',
        		   url:"${PATH}/role/save",
        		   data:{name:name},
        		   success:function(result){
        			   if('ok'==result){
        				   layer.msg("保存成功",function(){
        					   $("#addModal").modal('hide');
        					   initData(1);
        				   });
        			   }else{
        				   layer.msg("保存失败");
        			   }
        		   }        		   
        	   });
           }); 
            
           //===========修改==========================================================
           /* $(".updateBtnClass").click(function(){  //页面后局部刷新出来的元素不能直接使用click函数
        	   var roleId = $(this).attr("roleId");
        	   //查询数据
        	   $.get("${PATH}/role/get",{roleId:roleId},function(result){
        		   //回显数据
            	   $("#updateModal input[name='name']").val(result.name);
            	   
            	   //弹出模态框
            	   $("#updateModal").modal({
            		   show:true,
            		   backdrop:'static',
            		   keyboard:false
            	   });
        	   }); 
           }); */
           
           $("tbody").on("click",".updateBtnClass",function(){
        	   var roleId = $(this).attr("roleId");
        	   //查询数据
        	   $.get("${PATH}/role/get",{roleId:roleId},function(result){
        		   //回显数据
            	   $("#updateModal input[name='name']").val(result.name);
            	   $("#updateModal input[name='id']").val(result.id);
            	   
            	   //弹出模态框
            	   $("#updateModal").modal({
            		   show:true,
            		   backdrop:'static',
            		   keyboard:false
            	   });
        	   }); 
           });
           
           
           $("#updateBtn").click(function(){
        	   var id = $("#updateModal input[name='id']").val();
        	   var name = $("#updateModal input[name='name']").val();
        	   $.ajax({
        		   type:'post',
        		   url:"${PATH}/role/update",
        		   data:{id:id,name:name},
        		   success:function(result){
        			   if('ok'==result){
        				   layer.msg("修改成功",function(){
        					   $("#updateModal").modal('hide');
        					   initData(json.pageNum);
        				   });
        			   }else{
        				   layer.msg("修改失败");
        			   }
        		   }        		   
        	   });
           }); 
           //=========删除==========================================
           $("tbody").on("click",".deleteBtnClass",function(){ 
        	   
        	   var roleId = $(this).attr("roleId");
        	   
        	   layer.confirm("您确定要删除这条数据吗?",{btn:['确定','取消']},function(index){
        		  
            	   //查询数据
            	   $.post("${PATH}/role/delete",{roleId:roleId},function(result){
            		   if('ok'==result){
        				   layer.msg("删除成功");
        				   initData(json.pageNum);
        			   }else{
        				   layer.msg("删除失败");
        			   }            	   
            	   }); 
        		   layer.close(index);
        	   },function(index){
        		   layer.close(index);
        	   });
           });   
        	
           //========给角色分配许可  生成分配树===================================================
        	var roleId ;
        	$("tbody").on("click",".assignBtnClass",function(){ 
          	   
          	     var rid = $(this).attr("roleId");
          	     
          	      roleId = rid ;
          	     
          	      //发起多个异步请求，如果业务上有顺序，必须串行。
          	      
          	     //初始化树
          	     initTree();
          	      
          	 	 //回显
         	     //initShow();
          	     
	          	 $("#assignModal").modal({
	      		     show:true,
	      		     backdrop:'static',
	      		     keyboard:false
	      	     });
            });   
           
        	function initTree(){
        		
        		var setting = {
        				check: {
        					enable: true
        				},
        				data: {
        					simpleData: {
        						enable: true,
        						pIdKey: "pid"
        					},
        					key: {
        						url: "xxxx",
        						name:"title"
        					}
        				},
        				view: {
        					addDiyDom: function(treeId,treeNode){
        						$("#"+treeNode.tId+"_ico").removeClass();
        						$("#"+treeNode.tId+"_span").before('<span class="'+treeNode.icon+'"></span>');
        					}
        				}
        				
        		};
        		
        		//1.加载数据
        		$.get("${PATH}/permission/listAllPermissionTree",function(data){			
        			//data.push({"id":0,"title":"系统权限","icon":"glyphicon glyphicon-asterisk"});
        			
        			var tree = $.fn.zTree.init($("#treeDemo"), setting, data);
        			var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
        			treeObj.expandAll(true);
        			
        			//回显
            	    initShow();
        		}); 

        	}
        	
        	//回显。
        	function initShow(){
        		//根据角色id查询已经分配的许可id
        		$.get("${PATH}/role/listPermissionIdByRoleId",{roleId:roleId},function(data){	//List<Integer>	 =>>  [1,2,3,4,5,6]	 
        			$.each(data,function(i,e){
        				var permissionId = e;
        				var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
        				var node = treeObj.getNodeByParam("id", permissionId, null);
        				treeObj.checkNode(node,true,false,false);
        			});
        		}); 
        	}
        	
        	
        	//=======给角色分配许可   实现分配功能=======================================================
        	$("#assignBtn").click(function(){        		
        		
        		var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
        		var nodes = treeObj.getCheckedNodes(true);
        		
        		var data = '';
        		$.each(nodes,function(i,e){  //   e ==》》》  permission
            		var permissionId = e.id;
            		data+='id='+permissionId;
            		data+='&';
            	});
            	
            	data+="roleId="+roleId;
            	
            	$.post("${PATH}/role/doAssignPermissionToRole",data,function(result){
            		if("ok"==result){            			
            			layer.msg("分配成功");
            			$("#assignModal").modal('hide');
            		}else{
            			layer.msg("分配失败");
            		}
            	});
        	});	
        		
        		
        		
        		
        		
        		
        		
        		
        		
        		
        		
        		
        		
        		
        		
        		
        </script>
  </body>
</html>
    