<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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
				<h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 菜单树</h3>
			  </div>
			  <div class="panel-body">
					<ul id="treeDemo" class="ztree"></ul>
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
			<label>菜单名称</label>
			<input type="hidden" name="pid">
			<input type="text" class="form-control" name="name" placeholder="请输入菜单名称">
		  </div>
		  <div class="form-group">
			<label>菜单URL</label>
			<input type="text" class="form-control" name="url" placeholder="请输入菜单URL">
		  </div>
		  <div class="form-group">
			<label>菜单图标</label>
			<input type="text" class="form-control" name="icon" placeholder="请输入菜单图标">
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
			<label>菜单名称</label>
			<input type="hidden" name="id">
			<input type="text" class="form-control" name="name" placeholder="请输入菜单名称">
		  </div>
		  <div class="form-group">
			<label>菜单URL</label>
			<input type="text" class="form-control" name="url" placeholder="请输入菜单URL">
		  </div>
		  <div class="form-group">
			<label>菜单图标</label>
			<input type="text" class="form-control" name="icon" placeholder="请输入菜单图标">
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
            
            	initTree();
            
            });
            
            function initTree(){
            	var setting = {
            			data: {
            				simpleData: {
            					enable: true,
            					pIdKey:'pid'
            				}
            			},
            			view:{
            				addDiyDom:function(treeId,treeNode){  //treeNode  -->>>  TMenu
            					$("#"+treeNode.tId+"_ico").removeClass();//.addClass();
            					$("#"+treeNode.tId+"_span").before("<span class='"+treeNode.icon+"'></span>");
            				},
            				addHoverDom: function(treeId, treeNode){  // treeNode ==>> TMenu 
            					var aObj = $("#" + treeNode.tId + "_a");            				
            					//aObj.attr("href", "javascript:;"); //禁用href属性            					
            					aObj.attr("href", "#"); //禁用href属性 
            					aObj.attr("onclick","return false;");
            					
    							
    							if (treeNode.editNameFlag || $("#btnGroup"+treeNode.tId).length>0) return;
    							
    							var s = '<span id="btnGroup'+treeNode.tId+'">';
    							if ( treeNode.level == 0 ) { //根节点
    								s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="add('+treeNode.id+')" >&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
    							} else if ( treeNode.level == 1 ) { //分支节点
    								s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="update('+treeNode.id+')"  title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
    								if (treeNode.children.length == 0) { //分支节点没有孩子节点，可以进行删除
    									s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="remove('+treeNode.id+')" >&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
    								}
    								s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="add('+treeNode.id+')">&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
    							} else if ( treeNode.level == 2 ) {//叶子节点
    								s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  onclick="update('+treeNode.id+')" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
    								s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="remove('+treeNode.id+')">&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
    							}
    			
    							s += '</span>';
    							aObj.after(s);
    						},
    						removeHoverDom: function(treeId, treeNode){
    							$("#btnGroup"+treeNode.tId).remove();
    						}
            			}
            	};

            	$.get("${PATH}/menu/loadTree",{},function(result){  
            		//  List<TMenu>  --->>>  [{id:1,name:'根菜单'},{id:2,name:'权限管理'},{...}]
            		var zNodes = result;  
            		
            		//增加根节点
            		zNodes.push({"id":0,"name":"系统权限菜单","icon":"glyphicon glyphicon-th-list","url":"main.html","children":[]});
            		
            		console.log(zNodes);
            		
           			$.fn.zTree.init($("#treeDemo"), setting, zNodes);
           			
           			
           			var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
           			treeObj.expandAll(true);
            	});
            	
            }
            
            //==========================================================================
            	
            function add(id){
            	$("#addModal input[name='pid']").val(id);
                $("#addModal").modal({
          		   show:true,
          		   backdrop:'static',
          		   keyboard:false
          	    });
            }	
            
            $("#saveBtn").click(function(){
         	   var pid = $("#addModal input[name='pid']").val();
         	   var name = $("#addModal input[name='name']").val();
         	   var icon = $("#addModal input[name='icon']").val();
         	   var url = $("#addModal input[name='url']").val();
         	   $.ajax({
         		   type:'post',
         		   url:"${PATH}/menu/save",
         		   data:{pid:pid,name:name,icon:icon,url:url},
         		   success:function(result){
         			   if('ok'==result){
         				   layer.msg("保存成功",function(){
         					  $("#addModal").modal('hide');
         					  initTree();
         					  $("#addModal input[name='pid']").val("");
         		         	  $("#addModal input[name='name']").val("");
         		         	  $("#addModal input[name='icon']").val("");
         		         	  $("#addModal input[name='url']").val("");
         				   });
         			   }else{
         				   layer.msg("保存失败");
         			   }
         		   }        		   
         	   });
            }); 
            
            
            //~~~~~~修改功能~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            function update(id){
            	
            	 //查询数据
         	    $.get("${PATH}/menu/get",{id:id},function(result){
         		   //回显数据
             	   $("#updateModal input[name='id']").val(result.id);
             	   $("#updateModal input[name='name']").val(result.name);
             	   $("#updateModal input[name='icon']").val(result.icon);
             	   $("#updateModal input[name='url']").val(result.url);
             	   
             	   //弹出模态框
             	   $("#updateModal").modal({
             		   show:true,
             		   backdrop:'static',
             		   keyboard:false
             	   });
         	    }); 

            }
            
            
            $("#updateBtn").click(function(){
          	   var id = $("#updateModal input[name='id']").val();
          	   var name = $("#updateModal input[name='name']").val();
          	   var icon = $("#updateModal input[name='icon']").val();
          	   var url = $("#updateModal input[name='url']").val();
          	   $.ajax({
          		   type:'post',
          		   url:"${PATH}/menu/update",
          		   data:{id:id,name:name,icon:icon,url:url},
          		   success:function(result){
          			   if('ok'==result){
          				   layer.msg("修改成功",function(){
          					  $("#updateModal").modal('hide');
          					  initTree();
          				   });
          			   }else{
          				   layer.msg("修改失败");
          			   }
          		   }        		   
          	   });
             }); 
            
            //--------删除功能---------------------------------------------------------
            function remove(id){
             	   
             	   layer.confirm("您确定要删除这条数据吗?",{btn:['确定','取消']},function(index){
             		  
                 	   //查询数据
                 	   $.post("${PATH}/menu/delete",{id:id},function(result){
                 		   if('ok'==result){
             				   layer.msg("删除成功");
             				   initTree(); 
             			   }else{
             				   layer.msg("删除失败");
             			   }            	   
                 	   }); 
             		   layer.close(index);
             	   },function(index){
             		   layer.close(index);
             	   });
                
            }
    		

            
        </script>
  </body>
</html>
    