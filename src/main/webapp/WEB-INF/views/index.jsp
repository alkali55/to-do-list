<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
	let memoDataOrigin = [];
	let dangerToDo = [];
	let memberName = "";

	$(function(){

		

		if($("#toGetName").text() != ""){
			callToDoList();
		}
		createDangerToDo();

		memberName = $("#toGetName").text();
		console.log(memberName);

		if(dangerToDo[0] != null){
			showDangerToDo();
		} else if (memoDataOrigin[0] != null){
			showFastestToDo();
		} else {

			let output = `<h2 id="forBottomMargin">남은 할 일이 없습니다!</h2>`;
			output = `<h3>새로운 할 일을 추가해 보세요!</h3>`;
			output += `<a href="/toDo/register" class="btn btn-outline-primary regBtn" onclick="moveRegPage()">새 할 일 등록하기</a>`
			$("#mainBox").html(output);
			
		}

		
	})

	function showFastestToDo(){
		let output = `<h2 id="forBottomMargin">\${memberName}님의 다음 할 일</h2>`;
		output += `<div class="list-group" id="toDoBox">`;
		output += `<a href="#" class="list-group-item list-group-item-action toDoBox" id="tno-\${memoDataOrigin[0].tno}" data-tno="\${memoDataOrigin[0].tno}">`;
		output += `<span class="toDo">\${memoDataOrigin[0].toDo} </span> <span class="dueDate">\${memoDataOrigin[0].dueDate}</span>`;
		output += `</a>`;
		output += `</div>`
		output += `<div class="list-group-item btnBox">`;
		output += `<a href="/toDo/list" class="btn btn-outline-primary listBtn" onclick="moveListPage()">확인하러 가기</a>`
		output += `<a href="/toDo/register" class="btn btn-outline-primary regBtn" onclick="moveRegPage()">새 할 일 등록하기</a>`
		output += `</div>`;

		$("#mainBox").html(output);
	}

	function createDangerToDo(){

		$.each(memoDataOrigin, function(i, item){
			let remainDay = calculateRemainDay(item.dueDate);
			if(remainDay >= 0 && remainDay <=3 && !item.finished){
				dangerToDo.push(item);
			}
		});

	}

	function showDangerToDo(){
		let output = `<h2 id="forBottomMargin">\${memberName}님의 마감이 임박한 할 일</h2>`;
		output += `<div class="list-group" id="toDoBox">`;

		$.each(dangerToDo, function(i, item){
			output += `<a href="#" class="list-group-item list-group-item-action list-group-item-danger toDoBox" id="tno-\${item.tno}" data-tno="\${item.tno}">`;
			output += `<span class="toDo">\${item.toDo} </span> <span class="dueDate">\${item.dueDate}</span>`;
			output += `</a>`;
		})

		output += `</div>`
		output += `<div class="list-group-item btnBox">`;
		output += `<a href="/toDo/list" class="btn btn-outline-primary listBtn" onclick="moveListPage()">확인하러 가기</a>`
		output += `<a href="/toDo/register" class="btn btn-outline-primary regBtn" onclick="moveRegPage()">새 할 일 등록하기</a>`
		output += `</div>`;
		$("#mainBox").html(output);
			
	}

	function callToDoList(){

		$.ajax({
			url: '/toDo/notFinishedList', // 데이터가 송수신될 서버의 주소
			type: "POST", // 통신 방식 (GET, POST, PUT, DELETE)
			dataType: "json", // 수신받을 데이터 타입 (MIME TYPE) (text, json, xml)
			async: false, // 동기 통신 방식
			success: function (data) {
			// 통신이 성공하면 수행할 함수

			$.each(data, function(i, item){
				let remainDay = calculateRemainDay(item.dueDate);
				if (remainDay >= 0) {
					memoDataOrigin.push(item);
				}
			})
			console.log(memoDataOrigin);
			
			
			},
			error: function () {},
			complete: function () {
			},
		});

		}

	function calculateRemainDay(dueDateParam){
		let dueDate = new Date (dueDateParam);
		let tmpday = new Date();
		let tmpStr = `\${tmpday.getFullYear()}-\${tmpday.getMonth() + 1}-\${tmpday.getDate()}`;
		let today = new Date(tmpStr);

		let remainDay = Math.floor((dueDate - today) / 1000 / 60 / 60 / 24);
		return remainDay;
	}
</script>
<style>
	.dueDate {
		margin-left: 20px;
	}

	.btn {
		margin-top: 20px;

	}

	.regBtn {
		margin-left: 20px;
	}
	
	#forBottomMargin{
		margin-bottom: 50px;
	}
</style>
<body>
	<jsp:include page="header.jsp"></jsp:include>
	<div style="display: none;" id="toGetName">${loginMember.memberName}</div>
	<div class="container mt-5">
		<div class="row">
	
			<c:choose>
				<c:when test="${loginMember == null }">
				
					<!-- 회원가입 or 로그인하러가기 -->
					 <div>

						<h2>ToDoList에 오신 걸 환영합니다</h2>

						<h3>로그인이나 회원가입 후 이용부탁드립니다.</h3>
					 </div>
				
				</c:when>
				<c:otherwise>
					<div id="mainBox">

					</div>
				</c:otherwise>	
			
			
			
			</c:choose>
		</div>
	</div>
	<jsp:include page="footer.jsp"></jsp:include>
</body>
</html>