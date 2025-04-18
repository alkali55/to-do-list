<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>

	function dueDateValid(){
		let dueDate = new Date($("#dueDate").val());
		let today = new Date();

		if(dueDate.getFullYear() > today.getFullYear() || 
			dueDate.getFullYear() == today.getFullYear() && dueDate.getMonth() > today.getMonth() ||
			dueDate.getFullYear() == today.getFullYear() && dueDate.getMonth() == today.getMonth() && dueDate.getDate() >= today.getDate() ){
			
				return true;
		}

		return false;
	}

	function toDoLengthValid(){

		if ($("#toDo").val().length <= 100){
			return true;
		}

		return false;
	}

	function isValid(){
		let result = false;
		let toDoLengthValidCheck = toDoLengthValid();
		let dueDateValidCheck = dueDateValid();
		
		if(toDoLengthValidCheck && dueDateValidCheck){
			result = true;
		}

		return result;
	}
</script>
<body>
	<jsp:include page="../header.jsp"></jsp:include>
	<div class="container mt-5">
		<div class="row">
	
			<h1>할 일 등록</h1>
			
			<form action="register" method="POST">
			    <div class="mb-3 mt-3">
			      <label for="toDo">할 일:</label>
			      <input type="text" class="form-control" id="toDo" placeholder="할 일을 입력하세요" name="toDo">
			    </div>
			    <div class="mb-3">
			      <label for="dueDate">마감일 :</label>
			      <input type="date" class="form-control" id="dueDate" name="dueDateStr">
			    </div>
			    <button type="submit" class="btn btn-primary" onclick="return isValid();">등록</button>
			    <button type="reset" class="btn btn-secondary">취소</button>
			 </form>
		</div>
	</div>
	<jsp:include page="../footer.jsp"></jsp:include>
</body>
</html>