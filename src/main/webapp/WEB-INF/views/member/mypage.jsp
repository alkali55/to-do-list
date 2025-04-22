<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>
	$(function(){

		// 비밀번호 변경 버튼 클릭
		$("#modifyPwdBtn").click(function(e){
			e.preventDefault();
			makePwdModal();
			$("#saveBtn").attr("onclick", "savePwd();")
			$(".modal-title").text("비밀번호 변경");
			$("#modifyModal").show();
		});

		// pwd 정규식 검사
		$("body").on("keyup", "#modifyPwd1", function(){
			$("#modifyPwdValid").val("");
			let tmpPwd = $("#modifyPwd1").val();
			const regex_pwd = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[@$!%*?&#.~_-])[A-Za-z\d@$!%*?&#.~_-]{8,20}$/;

			if(!regex_pwd.test(tmpPwd)){
				// 비밀번호 정규식 불통과
				outputError("비밀번호는 8~20자리 영문과 숫자, 특수문자의 조합으로 해주세요", this, "red");
			} else {
				outputError("사용가능한 비밀번호입니다.", this, "green");
				isEqualPwd();
			}


		});

		// pwd2 일치여부 검사
		$("body").on("keyup", "#modifyPwd2", function(){
			$("#modifyPwdValid").val("");
			isEqualPwd();
		})

		// 이메일 변경 버튼 클릭
		$("#modifyEmailBtn").click(function(e){
			e.preventDefault();
		});

		// 이름 변경 버튼 클릭
		$("#modifyNameBtn").click(function(e){
			e.preventDefault();
		});



		// 모달 닫기 버튼
		$(".closeModal").click(function(){
			$("#modifyModal").hide();
		});
	})

	function isEqualPwd(){
		let pwd1 = $("#modifyPwd1").val();
		let pwd2 = $("#modifyPwd2").val();

		if (pwd1 == pwd2){
			outputError("비밀번호가 일치합니다", $("#modifyPwd2"), "green");
			$("#modifyPwdValid").val("checked");
		} else {
			outputError("비밀번호가 일치하지 않습니다", $("#modifyPwd2"), "red");
		}
	}

	function savePwd(){
		// 비밀번호 정규식 false면 여기서 리턴
		if($("#modifyPwdValid").val() != "checked"){
			return false;
		}

		let modifyPwd = $("#modifyPwd1").val();
		$("#memberPwd").val(modifyPwd);
		$("#modifyModal").hide();
	}

	function makePwdModal(){
		let output = ``;
		output += `<div class="mb-3 mt-3">`;
		output += `<label for="modifyPwd" class="form-label">변경할 비밀번호:</label><span></span>`;
		output += `<input type="password" class="form-control" id="modifyPwd1" placeholder="변경할 비밀번호를 입력하세요">`;
		output += `<input type="hidden" id="modifyPwdValid"/>`;
		output += `</div>`;
		output += `<div class="mb-3">`;
		output += `<label for="modifyPwd2" class="form-label">비밀번호 확인:</label><span></span>`;
		output += `<input type="password" class="form-control" id="modifyPwd2" placeholder="비밀번호를 다시 한 번 입력하세요">`;
		output += `</div>`;

		$(".modal-body").html(output);
	}

	function outputError(msg, tagObj, color){
		let errorObj = $(tagObj).prev();
		errorObj.html(msg);
		$(errorObj).css("color", color);
	}
</script>
<style>
	#title {
		margin-bottom: 50px;
	}
</style>
</head>
<body>
	<jsp:include page="../header.jsp"></jsp:include>
	<div class="container mt-5">
		<div class="row">
		
			<h1 id="title">내 정보 수정</h1>
			<form action="modifyMyInformation" method="post">

				<div class="input-group mb-3">
					<span class="input-group-text">아이디</span>
					<input type="text" class="form-control" value="${loginMember.memberId}" disabled="true" id="memberId" name="memberId">
				</div>

				<div class="input-group mb-3">
					<span class="input-group-text">비밀번호</span>
					<input type="password" class="form-control" disabled="true" id="memberPwd" name="memberPwd">
					<button class="btn btn-success" id="modifyPwdBtn">비밀번호 변경</button>
				</div>

				<div class="input-group mb-3">
					<span class="input-group-text">이메일</span>
					<input type="email" class="form-control" value="${loginMember.email}" disabled="true" id="email" name="email">
					<button class="btn btn-success" id="modifyEmailBtn">이메일 변경</button>
				</div>

				<div class="input-group mb-3">
					<span class="input-group-text">이름</span>
					<input type="text" class="form-control" value="${loginMember.memberName}" disabled="true" id="memberName" name="memberName">
					<button class="btn btn-success" id="modifyNameBtn">이름 변경</button>
				</div>
				<button type="submit" class="btn btn-primary">수정</button>
				<button class="btn btn-danger">회원탈퇴</button>
				<!-- 모달창으로 한번 더 확인 -->
			</form>
		</div>
	</div>

	<!-- The Modal -->
	<div class="modal" id="modifyModal">
		<div class="modal-dialog">
		  <div class="modal-content">
	  
			<!-- Modal Header -->
			<div class="modal-header">
				<!-- 아래 내용도 동적 -->
			  <h4 class="modal-title"></h4>
			  <button type="button" class="btn-close closeModal" data-bs-dismiss="modal"></button>
			</div>
	  
			<!-- Modal body -->
			<div class="modal-body">
			  
			  
			  
			</div>
	  
			<!-- Modal footer -->
			<div class="modal-footer">
				<!-- 아래도 동적 -->
			  <button type="button" class="btn btn-success" id="saveBtn">저장</button> 
			  <button type="button" class="btn btn-danger closeModal" data-bs-dismiss="modal">닫기</button>
			</div>
	  
		  </div>
		</div>
	</div>
	
	<jsp:include page="../footer.jsp"></jsp:include>
</body>
</html>