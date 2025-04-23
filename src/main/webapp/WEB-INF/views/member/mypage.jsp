<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script>

	let prevPwd = "";
	let prevEmail = "";
	let prevName = "";

	$(function(){

		prevPwd = $("#memberPwd").val();
		prevEmail = $("#email").val();
		prevName = $("#memberName").val();


		// 비밀번호 변경 버튼 클릭
		$("#modifyPwdBtn").click(function(e){
			e.preventDefault();
			makePwdModal();
			$("#saveBtn").attr("onclick", "savePwd();")
			$(".modal1-title").text("비밀번호 변경");
			$("#modifyModal").show();
		});

		// pwd 정규식 검사
		$("body").on("keyup", "#modifyPwd1", function(){
			$("#modifyPwdRegValid").val("");
			$("#modifyPwdValid").val("");
			let tmpPwd = $("#modifyPwd1").val();
			const regex_pwd = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[@$!%*?&#.~_-])[A-Za-z\d@$!%*?&#.~_-]{8,20}$/;

			if(!regex_pwd.test(tmpPwd)){
				// 비밀번호 정규식 불통과
				outputError("비밀번호는 8~20자리 영문과 숫자, 특수문자의 조합으로 해주세요", this, "red");
			} else {
				outputError("사용가능한 비밀번호입니다.", this, "green");
				$("#modifyPwdRegValid").val("checked");
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
			makeEmailModal();
			$("#saveBtn").attr("onclick", "saveEmail();")
			$(".modal1-title").text("이메일 변경");
			$("#modifyModal").show();
		});

		// 이메일 검사
		$("body").on("keyup", "#modifyEmail", function(){
			$("#emailRegValid").val("");
			if ($("#modifyEmail").val().length > 0) {
				checkEmail();
			} else {
				outputError("이메일은 필수항목입니다.", $("#modifyEmail"), "red");
			}
		});

		// 이메일 중복검사
		$("body").on("click", "#emailDupCheckBtn", function(){
			
			checkEmailDup();
		})

		// 인증메일 보내기
		$("body").on("click", "#sendEmail", function(){
			
			if($("#emailRegValid").val() != "checked"){
				return;
			}

			$("#modifyEmail").attr("disabled", true);
			sendMail();
		})

		// 이름 변경 버튼 클릭
		$("#modifyNameBtn").click(function(e){
			e.preventDefault();
			makeNameModal();
			$("#saveBtn").attr("onclick", "saveName();")
			$(".modal1-title").text("이름 변경");
			$("#modifyModal").show();
		});

		// 이름 검사
		$("body").on("keyup", "#modifyMemberName", function(){
			$("#modifyNameValid").val("");
			checkNameValid();
		})

		// 탈퇴 버튼
		$("#leaveBtn").click(function(e){
			e.preventDefault();
			$("#checkLeaveModal").show();
		})

		// 모달 닫기 버튼
		$(".closeModal").click(function(){
			$("#modifyModal").hide();
			$("#checkLeaveModal").hide();
		});
	

	});

	let count = 180;
	let timer;
	let stopper;

	function saveName(){
		if($("#modifyNameValid").val() != "checked"){
			return;
		}
		
		let modifyName = $("#modifyMemberName").val();
		$("#memberName").val(modifyName);
		$("#modifyModal").hide();
	}

	function checkNameValid(){

		if($("#modifyMemberName").val() == ""){
			outputError("이름은 필수 항목입니다", $("#modifyMemberName"), "red");
		} else {
			clearError($("#modifyMemberName"));
			$("#modifyNameValid").val("checked");
		}
	}

	function makeNameModal(){
		let output = `<div class="mb-3">`;
		output += `<label for="modifyMemberName">이름 : </label><span></span>`;
		output += `<input type="text" class="form-control" id="modifyMemberName" placeholder="이름을 입력하세요" name="memberName" >`;
		output += `<input type="hidden" id="modifyNameValid"/>`;
		output += `</div>`;

		$(".modal1-body").html(output);
	}

	function saveEmail(){
		if($("#emailValid").val() != "checked"){
			return false;
		}

		let modifyEmail = $("#modifyEmail").val();
		$("#email").val(modifyEmail);
		$("#modifyModal").hide();
	}
	
	function setTimer(){
		count = 180;
		let timerDate = new Date(count * 1000);
		let timerString = `\${timerDate.getMinutes()} : \${timerDate.getSeconds()}`;
		$(".timer").html(timerString);
		timer = setInterval(doTimer, 1000);
		// setTimeout(stopTimer, 180000);
	}

	function doTimer(){
		count--;
		if(count < 0){
			clearTimeout(timer);
			$(".timer").html("인증시간이 만료되었습니다.");

			$.ajax({
				url: '/member/clearAuthCode', // 데이터가 송수신될 서버의 주소
				type: "POST", // 통신 방식 (GET, POST, PUT, DELETE)
				dataType: "text", // 수신받을 데이터 타입 (MIME TYPE) (text, json, xml)
				// async: false, // 동기 통신 방식
				success: function (data) {
					// 통신이 성공하면 수행할 함수
					
					$("#authBtn").css("display", "none");
					$("#reAuthBtn").css("display", "block");
				},
				error: function () {},
				complete: function () {
				},
			});
			return;
		}
		let timerDate = new Date(count * 1000);
		let timerString = `\${timerDate.getMinutes()} : \${timerDate.getSeconds()}`;
		$(".timer").html(timerString);	
	}

	function reAuth(){
		$("#emailValid").val("");
		$("#modifyEmail").attr("disabled", false)
		clearError($("#modifyEmail"));
		$("#forCheckAuthDiv").empty();
		$("#emailDupCheckBtn").css("display", "block");

	}

	function checkAuthCode(){
		
		let memberAuthCode = $("#memberAuthCode").val();

		$.ajax({
			url: '/member/checkAuthCode', // 데이터가 송수신될 서버의 주소
			type: "POST", // 통신 방식 (GET, POST, PUT, DELETE)
			data: {
				"memberAuthCode" : memberAuthCode
			},  // 보내는 데이터
			dataType: "text", // 수신받을 데이터 타입 (MIME TYPE) (text, json, xml)
			// async: false, // 동기 통신 방식
			success: function (data) {
				// 통신이 성공하면 수행할 함수
				console.log(data);
				if(data == "true"){
					$(".timer").empty();
					$("#authBtn").css("display", "none");
					$("#memberAuthCode").css("display", "none");
					outputError("인증에 성공했습니다", $(".timer"), "green");
					$("#emailValid").val("checked");
					clearTimeout(timer);
					clearError($("#authBtn"));
				} else {
					outputError("잘못된 인증번호입니다", $("#authBtn"), "red");
				}
			
			},
			error: function () {},
			complete: function () {
			},
		});
		
	}

	function sendMail(){
		clearTimeout(timer);

		$.ajax({
			url: '/member/callSendMail', // 데이터가 송수신될 서버의 주소
			type: "POST", // 통신 방식 (GET, POST, PUT, DELETE)
			data: {
				"tmpMemberEmail" : $("#modifyEmail").val()
			},  // 보내는 데이터
			dataType: "text", // 수신받을 데이터 타입 (MIME TYPE) (text, json, xml)
			// async: false, // 동기 통신 방식
			success: function (data) {
			// 통신이 성공하면 수행할 함수
			console.log(data);
			if (data == "success"){
				alert("이메일로 인증번호를 발송했습니다. 인증코드를 입력해주세요.")
				
				if($(".authenticationDiv").length == 0){
					$("#sendEmail").css("display", "none");
					showAuthenticateDiv(); // 인증번호를 입력받을 태그 요소를 출력
				} else {

				}
			}
			
			},
			error: function () {},
			complete: function () {
			},
		});
	}

	function showAuthenticateDiv(){
	
		let authDiv = `<div class="authenticationDiv mt-2">
				<input type="text" class="form-control" id="memberAuthCode" placeholder="인증번호를 입력하세요.." />
				<div class="d-flex align-items-center">
				<span></span>
				<span class="timer">3:00</span>
				</div>
				<div></div>
				<button type="button" id="authBtn" class="btn btn-info" onclick="checkAuthCode();">인증하기</button>
				<button type="button" id="reAuthBtn" class="btn btn-success" onclick="reAuth();" style="display: none">다시 입력하기</button>
				<span></span>
				<div id="forAuthCheckErrorDiv" style="display: none;"></div>
				</div>`;
		
		// $(authDiv).insertAfter("#email");
		$("#forCheckAuthDiv").append(authDiv);
		
		setTimer();
		
	}

	function checkEmailDup(){
		if($("#emailRegValid").val() != "checked"){
			return;
		}

		let tmpEmail = $("#modifyEmail").val();

		$.ajax({
		      url: "/member/isDuplicatedEmail", // 데이터가 송수신될 서버의 주소
		      type: "POST", // 통신 방식 (GET, POST, PUT, DELETE)
			  data: {
				  tmpEmail : tmpEmail
			  },  // 보내는 데이터
		      dataType: "text", // 수신받을 데이터 타입 (MIME TYPE)
		      // async: false, // 동기 통신 방식
		      success: function (data) {
		        // 통신이 성공하면 수행할 함수
		        // console.log(data);
				if(data == "true"){
					outputError("이미 존재하는 이메일입니다.", $("#modifyEmail"), "red");
				} else {
					clearError($("#modifyEmail"));
					outputError("사용가능한 이메일입니다.", $("#modifyEmail"), "green")
					$("#sendEmail").css("display", "block");
					$("#emailDupCheckBtn").css("display", "none");
				}
			
		      },
		      error: function () {},
		      complete: function () {
		      },
    	});

	}

	function checkEmail(){

		let tmpMemberEmail = $("#modifyEmail").val();
		let emailRegExp = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

		if (!emailRegExp.test(tmpMemberEmail)){
			outputError("이메일 형식이 아닙니다.", $("#modifyEmail"), "red");
		} else {
			outputError("이메일 형식입니다.", $("#modifyEmail"), "green");
			$("#emailRegValid").val("checked");
			
		}
	}

	function makeEmailModal(){
		let output = `<div class="mb-3 mt-3">`;
		output += `<label for="modifyEmail">이메일 :</label><span></span>`;
		output += `<input type="email" class="form-control" id="modifyEmail" placeholder="이메일을 입력하세요">`;
		output += `<div id="forCheckAuthDiv"></div>`;
		output += `<input type="hidden" id="emailRegValid"/>`;
		output += `<input type="hidden" id="emailValid"/>`;
		output += `<button class="btn btn-success check-btn" id="emailDupCheckBtn">이메일 중복확인</button>`;
		output += `<button class="btn btn-primary check-btn" style="display: none;" id="sendEmail">인증메일 보내기</button>`;
		output += `</div>`;

		$(".modal1-body").html(output);
	}

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
		// 비밀번호 정규식 false면 여기서 리턴 < signup페이지에도 추가해야함
		if($("#modifyPwdValid").val() != "checked" || $("#modifyPwdRegValid").val() != "checked"){
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
		output += `<input type="hidden" id="modifyPwdRegValid"/>`;
		output += `<input type="hidden" id="modifyPwdValid"/>`;
		output += `</div>`;
		output += `<div class="mb-3">`;
		output += `<label for="modifyPwd2" class="form-label">비밀번호 확인:</label><span></span>`;
		output += `<input type="password" class="form-control" id="modifyPwd2" placeholder="비밀번호를 다시 한 번 입력하세요">`;
		output += `</div>`;

		$(".modal1-body").html(output);
	}

	function clearError(tagObj){
		let errorObj = $(tagObj).prev();
		$(errorObj).empty();
	}

	function outputError(msg, tagObj, color){
		let errorObj = $(tagObj).prev();
		errorObj.html(msg);
		$(errorObj).css("color", color);
	}

	function isValidModify(){

		if($("#memberPwd").val() == prevPwd && $("#email").val() == prevEmail && $("#memberName").val() == prevName ){
			return false;
		}

		$("#memberId").attr("disabled", false);
		$("#memberPwd").attr("disabled", false);
		$("#email").attr("disabled", false);
		$("#memberName").attr("disabled", false);

		return true;
	}
</script>
<style>
	#title {
		margin-bottom: 50px;
	}
	.check-btn {
		margin-top: 10px;
	}

	.timer {color : red }
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
				<button type="submit" class="btn btn-primary" onclick="return isValidModify();">수정</button>
				<button class="btn btn-danger" id="leaveBtn">회원탈퇴</button>
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
			  <h4 class="modal-title modal1-title"></h4>
			  <button type="button" class="btn-close closeModal" data-bs-dismiss="modal"></button>
			</div>
	  
			<!-- Modal body -->
			<div class="modal-body modal1-body">
			  
			  
			  
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

	<!-- The Modal2 -->
	<div class="modal" id="checkLeaveModal">
		<div class="modal-dialog">
		  <div class="modal-content">
	  
			<!-- Modal Header -->
			<div class="modal-header">
				<!-- 아래 내용도 동적 -->
			  <h4 class="modal-title">회원탈퇴</h4>
			  <button type="button" class="btn-close closeModal" data-bs-dismiss="modal"></button>
			</div>
	  
			<!-- Modal body -->
			<div class="modal-body">
			  
				정말 탈퇴하시겠습니까?
				<br/>
				<span style="color: red;">* 탈퇴하면 데이터의 복구가 불가능합니다 !!</span>
				
			  
			</div>
	  
			<!-- Modal footer -->
			<div class="modal-footer">
				<!-- 아래도 동적 -->
			  <form action="leaveMember" method="post">
			  	<button type="submit" class="btn btn-danger" id="confirmLeaveBtn">탈퇴</button> 
			  </form>
			  <button type="button" class="btn btn-secondary closeModal" data-bs-dismiss="modal">취소</button>
			</div>
	  
		  </div>
		</div>
	</div>
	
	<jsp:include page="../footer.jsp"></jsp:include>
</body>
</html>