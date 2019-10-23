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
<form id="queryForm" class="form-inline" role="form" style="float:left;" action="${PATH}/admin/index" method="post">
  <div class="form-group has-feedback">
    <div class="input-group">
      <div class="input-group-addon">查询条件</div>
      <input class="form-control has-success" type="text" name="condition" value="${param.condition }" placeholder="请输入查询条件">
    </div>
  </div>
  <button id="queryBtn" type="button" class="btn btn-warning"><i class="glyphicon glyphicon-search"></i> 查询</button>
</form>
<button id="deleteBatchBtn" type="button" class="btn btn-danger" style="float:right;margin-left:10px;"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
<button type="button" class="btn btn-primary" style="float:right;" onclick="window.location.href='${PATH}/admin/toAdd'"><i class="glyphicon glyphicon-plus"></i> 新增</button>
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
            function initData(pageNum){
            	
            	var json = {
            			pageNum:pageNum,
            			pageSize:2
            	};
            	
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
            		content+='	  <button type="button" class="btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>';
            		content+='	  <button type="button" class="btn btn-primary btn-xs"><i class=" glyphicon glyphicon-pencil"></i></button>';
            		content+='	  <button type="button" class="btn btn-danger btn-xs"><i class=" glyphicon glyphicon-remove"></i></button>';
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
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        </script>
  </body>
</html>
    