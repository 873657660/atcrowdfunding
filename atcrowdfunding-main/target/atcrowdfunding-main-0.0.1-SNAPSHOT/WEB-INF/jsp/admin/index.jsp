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
                <tr >
                  <th width="30">#</th>
				  <th width="30"><input id="selectAllCheckbox" type="checkbox"></th>
                  <th>账号</th>
                  <th>名称</th>
                  <th>邮箱地址</th>
                  <th width="100">操作</th>
                </tr>
              </thead>
              <tbody>
	              <c:forEach items="${page.list}" var="admin">
	                <tr>
	                  <td>1</td>
					  <td><input adminId="${admin.id}" type="checkbox"></td>
	                  <td>${admin.loginacct }</td>
	                  <td>${admin.username }</td>
	                  <td>${admin.email }</td>
	                  <td>
					      <button type="button" class="btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>
					      <button type="button" class="btn btn-primary btn-xs" onclick="window.location.href='${PATH}/admin/toUpdate?pageNum=${page.pageNum}&id=${admin.id}'"><i class=" glyphicon glyphicon-pencil"></i></button>
						  <button type="button" class="deleteBtnClass btn btn-danger btn-xs"  myhref="${PATH}/admin/doDelete?pageNum=${page.pageNum}&id=${admin.id}"><i class=" glyphicon glyphicon-remove"></i></button>
					  </td>
	                </tr>
	               </c:forEach> 
              </tbody>
			  <tfoot>
			     <tr >
				     <td colspan="6" align="center">
						<ul class="pagination">
								<c:if test="${page.isFirstPage}">
									<li class="disabled"><a href="#">上一页</a></li>
								</c:if>
								<c:if test="${!page.isFirstPage }">
									<li><a href="${PATH}/admin/index?condition=${param.condition}&pageNum=${page.pageNum-1}">上一页</a></li>
								</c:if>
								
								
								<!-- <li class="active"><a href="#">1 <span class="sr-only">(current)</span></a></li> -->
								<c:forEach items="${page.navigatepageNums }" var="num">
									<c:if test="${page.pageNum == num }">
										<li class="active"><a href="${PATH}/admin/index?condition=${param.condition}&pageNum=${num}">${num }</a></li>
									</c:if>
									<c:if test="${page.pageNum != num }">
										<li><a href="${PATH}/admin/index?condition=${param.condition}&pageNum=${num}">${num }</a></li>
									</c:if>
								</c:forEach>
								
								
								<c:if test="${page.isLastPage}">
									<li class="disabled"><a href="#">下一页</a></li>
								</c:if>
								<c:if test="${!page.isLastPage }">
									<li><a href="${PATH}/admin/index?condition=${param.condition}&pageNum=${page.pageNum+1}">下一页</a></li>
								</c:if>								
							 </ul>
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

            
            $("#queryBtn").click(function(){
            	$("#queryForm").submit();
            });	
            
            
            $(".deleteBtnClass").click(function(){
            	//var href = this.myhref ; // 自定义属性，不能通过DOM对象获取。
            	var href = $(this).attr("myhref");            	
            	layer.confirm("确定要删除这条数据?",{btn:['确认','取消']},function(index){
                	
                	layer.msg("删除成功",{time:1000,icon:6},function(){
                		layer.close(index);
                		window.location.href = href ;  
                	});
            		
            	},function(index){
            		layer.close(index);
            	});
            });
            
            
            
            
            
            $("#selectAllCheckbox").click(function(){
            	var checkStatus = this.checked ;
            	//$("tbody input[type='checkbox']").attr("checked",checkStatus); //表体复选框状态等于表头复选框状态
            	$("tbody input[type='checkbox']").prop("checked",checkStatus);
            });
            
            
            $("#deleteBatchBtn").click(function(){
            	// [<input adminId="1" type="checkbox">,<input adminId="2" type="checkbox">]
            	var tbodyCheckedList = $("tbody input[type='checkbox']:checked");
            	
            	if(tbodyCheckedList.length==0){
            		layer.msg("请先选择需要删除的数据",{time:2000});
            		return false ;
            	}
            	
            	var ids = ''; // 在js代码中，拼串推荐使用单引号。
            	
            	$.each(tbodyCheckedList,function(i,e){ // index  element
            		// e 是DOM对象 ==>>  <input adminId="1" type="checkbox">
            		//var adminId = e.adminId ; // DOM对象不能直接获取自定义属性值。
            		var adminId = $(e).attr("adminId") ;
            		//  url?ids=1,2,3
            		if(i!=0){
            			ids += ',' ;
            		}
            		ids += adminId ;
            	});
            	
				layer.confirm("确定要删除这些数据?",{btn:['确认','取消']},function(index){
                	
                	layer.msg("删除成功",{time:1000,icon:6},function(){
                		layer.close(index);
                		window.location.href = "${PATH}/admin/doDeleteBatch?pageNum=${page.pageNum}&ids="+ids ;  
                	});
            		
            	},function(index){
            		layer.close(index);
            	});
            });
            
            
            
            
            
        </script>
  </body>
</html>
    