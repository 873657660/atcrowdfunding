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
	</style>
  </head>

  <body>

    <jsp:include page="/WEB-INF/jsp/common/top.jsp"></jsp:include>

    <div class="container-fluid">
      <div class="row">
        <jsp:include page="/WEB-INF/jsp/common/menu.jsp"></jsp:include>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
				<ol class="breadcrumb">
				  <li><a href="#">首页</a></li>
				  <li><a href="#">数据列表</a></li>
				  <li class="active">分配角色</li>
				</ol>
			<div class="panel panel-default">
			  <div class="panel-body">
				<form role="form" class="form-inline">
				  <div class="form-group">
					<label for="exampleInputPassword1">未分配角色列表</label><br>
					<select id="leftRoleList" class="form-control" multiple size="10" style="width:250px;overflow-y:auto;">
                        <c:forEach items="${unAssignRoleList}" var="role">
                        	<option value="${role.id }">${role.name }</option>
                        </c:forEach>
                    </select>
				  </div>
				  <div class="form-group">
                        <ul>
                            <li id="leftToRightBtn" class="btn btn-default glyphicon glyphicon-chevron-right"></li>
                            <br>
                            <li id="rightToLeftBtn" class="btn btn-default glyphicon glyphicon-chevron-left" style="margin-top:20px;"></li>
                        </ul>
				  </div>
				  <div class="form-group" style="margin-left:40px;">
					<label for="exampleInputPassword1">已分配角色列表</label><br>
					<select id="rightRoleList" class="form-control" multiple size="10" style="width:250px;overflow-y:auto;">
                        <c:forEach items="${assignRoleList}" var="role">
                        	<option value="${role.id }">${role.name }</option>
                        </c:forEach>
                    </select>
				  </div>
				</form>
			  </div>
			</div>
        </div>
      </div>
    </div>
	
   <%@ include file="/WEB-INF/jsp/common/js.jsp" %>
        <script type="text/javascript">
            $(function () {
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
            });
            
            
            //分配按钮
            $("#leftToRightBtn").click(function(){
            	var leftSelectedOptions = $("#leftRoleList option:selected");
            	
            	if(leftSelectedOptions.length == 0){
            		layer.msg("请选择分配的角色!再进行分配角色");
            		return false ;
            	}
            	
            	var adminId = "${param.adminId}";
            	
            	var data = '';//'id=1&id=2&id=3&adminId=1';
            	
            	$.each(leftSelectedOptions,function(i,e){
            		var roleId = e.value;
            		data+='id='+roleId;
            		data+='&';
            	});
            	
            	data+="adminId="+adminId;
            	
            	$.post("${PATH}/admin/doAssignRoleToAdmin",data,function(result){
            		if("ok"==result){
            			$("#rightRoleList").append(leftSelectedOptions.clone());
                    	leftSelectedOptions.remove();
            			layer.msg("分配成功");
            		}else{
            			layer.msg("分配失败");
            		}
            	});
            	
            });
            
            //取消分配按钮
 			$("#rightToLeftBtn").click(function(){
 				var rightSelectedOptions = $("#rightRoleList option:selected");
 				
 				if(rightSelectedOptions.length == 0){
            		layer.msg("请选择已分配的角色!再进行取消分配");
            		return false ;
            	}

            	var adminId = "${param.adminId}";
            	
            	var data = '';//'id=1&id=2&id=3&adminId=1';
            	
            	$.each(rightSelectedOptions,function(i,e){
            		var roleId = e.value;
            		data+='id='+roleId;
            		data+='&';
            	});
            	
            	data+="adminId="+adminId;
            	
            	$.post("${PATH}/admin/doUnAssignRoleToAdmin",data,function(result){
            		if("ok"==result){
            			$("#leftRoleList").append(rightSelectedOptions.clone());
                    	rightSelectedOptions.remove();
            			layer.msg("取消分配成功");
            		}else{
            			layer.msg("取消分配失败");
            		}
            	});
            });
            
            
            
            
            
            
            
            
            
            
        </script>
  </body>
</html>
    