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
	$(function(){
		// id 정규식 검사
		$("#memberId").keyup(function(){
			// console.log("확인용");
			$("#idRegValid").val("");
			$("#idValid").val("");
			clearError(this);

			const regType1 = /^[A-Za-z0-9]{4,12}$/;
			let tmpId = $("#memberId").val();
			
			if(!regType1.test(tmpId)){
				// 아이디 정규식 불통과
				outputError("아이디는 4~12자리 영문과 숫자의 조합으로 해주세요", this, "red");
				$("#idRegValid").val("");
			} else {
				$("#idRegValid").val("checked");
				$("#idDupCheckBtn").css("display", "block")
			}
		});
		
		// id 중복 검사
		$("#idDupCheckBtn").click(function(e){
			e.preventDefault();
			checkIdDup();
		});
		
		// pwd 정규식 검사
		$("#memberPwd1").keyup(function(){
			$("#pwdRegValid").val("");
			$("#pwdValid").val("");

			let tmpPwd = $("#memberPwd1").val();
			const regex_pwd = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[@$!%*?&#.~_-])[A-Za-z\d@$!%*?&#.~_-]{8,20}$/;

			if(!regex_pwd.test(tmpPwd)){
				// 비밀번호 정규식 불통과
				outputError("비밀번호는 8~20자리 영문과 숫자, 특수문자의 조합으로 해주세요", this, "red");
			} else {
				outputError("사용가능한 비밀번호입니다.", this, "green");
				$("#pwdRegValid").val("checked");
				isEqualPwd();
			}


		})

		// pwd2 일치여부 검사
		$("#memberPwd2").keyup(function(){
			$("#pwdValid").val("");
			isEqualPwd();
		})
	
		// 이메일 검사
		$("#email").keyup(function(){
			$("#emailRegValid").val("");
			if ($("#email").val().length > 0) {
				checkEmail();
			} else {
				outputError("이메일은 필수항목입니다.", $("#email"), "red");
			}
		});

		// 이메일 중복검사
		$("#emailDupCheckBtn").click(function(e){
			e.preventDefault();
			checkEmailDup();
		})

		// 인증메일 보내기
		$("#sendEmail").click(function(e){
			e.preventDefault();

			if($("#emailRegValid").val() != "checked"){
				return;
			}

			$("#email").attr("disabled", true);
			sendMail();
		})

	});

	// 타이머 변수
	let count = 180;
	let timer;
	let stopper;


	function setTimer(){
		count = 180;
		let timerDate = new Date(count * 1000);
		let timerString = `\${timerDate.getMinutes()} : \${timerDate.getSeconds()}`;
		$(".timer").html(timerString);
		timer = setInterval(doTimer, 1000);
		// setTimeout(stopTimer, 180000);
	}

	// function stopTimer(){

	// 	if($("#emailValid").val() != "checked"){

	// 		clearTimeout(timer);
	// 		$(".timer").html("인증시간이 만료되었습니다.");

	// 		$.ajax({
	// 			url: '/member/clearAuthCode', // 데이터가 송수신될 서버의 주소
	// 			type: "POST", // 통신 방식 (GET, POST, PUT, DELETE)
	// 			dataType: "text", // 수신받을 데이터 타입 (MIME TYPE) (text, json, xml)
	// 			// async: false, // 동기 통신 방식
	// 			success: function (data) {
	// 				// 통신이 성공하면 수행할 함수
					
	// 				$("#authBtn").css("display", "none");
	// 				$("#reAuthBtn").css("display", "block");
	// 			},
	// 			error: function () {},
	// 			complete: function () {
	// 			},
	// 		});

	// 	}
	// }

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
		$("#email").attr("disabled", false)
		clearError($("#email"));
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
				// console.log(data);
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
				"tmpMemberEmail" : $("#email").val()
			},  // 보내는 데이터
			dataType: "text", // 수신받을 데이터 타입 (MIME TYPE) (text, json, xml)
			// async: false, // 동기 통신 방식
			success: function (data) {
			// 통신이 성공하면 수행할 함수
			// console.log(data);
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

		let tmpEmail = $("#email").val();

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
					outputError("이미 존재하는 이메일입니다.", $("#email"), "red");
				} else {
					clearError($("#email"));
					outputError("사용가능한 이메일입니다.", $("#email"), "green")
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

		let tmpMemberEmail = $("#email").val();
		let emailRegExp = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
		
		if (!emailRegExp.test(tmpMemberEmail)){
			outputError("이메일 형식이 아닙니다.", $("#email"), "red");
		} else {
			outputError("이메일 형식입니다.", $("#email"), "green");
			$("#emailRegValid").val("checked");
			
		}
	}

	function isEqualPwd(){
		let pwd1 = $("#memberPwd1").val();
		let pwd2 = $("#memberPwd2").val();

		if (pwd1 == pwd2){
			outputError("비밀번호가 일치합니다", $("#memberPwd2"), "green");
			$("#pwdValid").val("checked");
		} else {
			outputError("비밀번호가 일치하지 않습니다", $("#memberPwd2"), "red");
		}
	}

	function checkIdDup(){
		if ($("#idRegValid").val() != "checked"){
			return;
		}

		let tmpMemberId = $("#memberId").val();

		// console.log(tmpMemberId);
		$.ajax({
	          url: "/member/isDuplicatedId", // 데이터가 송수신될 서버의 주소
	          type: "POST", // 통신 방식 (GET, POST, PUT, DELETE)
			  data: {
				  tmpMemberId : tmpMemberId
			  },  // 보내는 데이터
	          dataType: "text", // 수신받을 데이터 타입 (MIME TYPE)
	          // async: false, // 동기 통신 방식
	          success: function (data) {
	            // 통신이 성공하면 수행할 함수
	            // console.log(data);
				if(data == "true"){
					outputError("이미 존재하는 아이디입니다.", $("#memberId"), "red");
				} else {
					clearError($("#memberId"));
					$("#idValid").val("checked");
					outputError("사용가능한 아이디입니다.", $("#memberId"), "green")
				}
	            
	          },
	          error: function () {},
	          complete: function () {
	          },
        	});
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
	
	function resetForm(){
		$("#idRegValid").val("");
		$("#idValid").val("");
		$("#pwdValid").val("");
		$("#emailRegValid").val("");
		$("#emailValid").val("");
		$("#email").attr("disabled", false);
		clearError($("#memberId"));
		clearError($("#memberPwd1"));
		clearError($("#memberPwd2"));
		clearError($("#email"));
		clearError($(".timer"));
		$("#forCheckAuthDiv").empty();
	}

	function  isValid(){
		let result = false;

		
		let idCheck = idValid();
		let pwdCheck = pwdValid();
		let emailCheck = emailValid();
		let nameCheck = nameValid();

		if (idCheck && pwdCheck && emailCheck && nameCheck){
			$("#email").attr("disabled", false);
			result = true;
		} else {
			outputError("입력정보를 다시 확인해주세요", $("#forSignUpError"), "red")
		}

		return result;

	}

	function idValid(){
		let result = false;
		if($("#idValid").val() == "checked"){
			result = true;
		}
		return result;
	}

	function pwdValid(){
		let result = false;
		if($("#pwdValid").val() == "checked" && $("#pwdRegValid").val() == "checked"){
			result = true;
		}
		return result;
	}

	function emailValid(){
		// console.log($("#email").val());
		let result = false;
		if($("#emailValid").val() == "checked"){
			result = true;
		}
		return result;
	}

	function nameValid(){
		let result = false;

		if($("#memberName").val() == ""){
			outputError("이름은 필수 항목입니다", $("#memberName"), "red");
		} else {
			clearError($("#memberName"));
			result = true;
		}

		return result;
	}

</script>
<style>
	.check-btn {
		margin-top: 10px;
	}

	.timer {color : red }
</style>
<body>
	<jsp:include page="../header.jsp"></jsp:include>
	<div class="container mt-5">
		<div class="row">
	
			<form action="signup" method="POST">
			    <div class="mb-3 mt-3">
			      <label for="memberId">아이디 :</label><span></span>
			      <input type="text" class="form-control" id="memberId" name="memberId" placeholder="아이디를 입력하세요" >
			      <input type="hidden" id="idRegValid"/>
			      <input type="hidden" id="idValid"/>
			      <button class="btn btn-success check-btn" id="idDupCheckBtn">아이디 중복확인</button>
			    </div>
			    <div class="mb-3">
			      <label for="memberPwd1">비밀번호 : </label><span></span>
			      <input type="password" class="form-control" id="memberPwd1" placeholder="비밀번호를 입력하세요" name="memberPwd">
				  <input type="hidden" id="pwdRegValid"/>
			    </div>
		    	<div class="mb-3">
			      <label for="memberPwd2">비밀번호 확인 : </label><span></span>
			      <input type="password" class="form-control" id="memberPwd2" placeholder="비밀번호를 다시 한번 입력하세요" >
			      <input type="hidden" id="pwdValid"/>
			    </div>
			    <div class="mb-3 mt-3">
			      <label for="email">이메일 :</label><span></span>
			      <input type="email" class="form-control" id="email" placeholder="이메일을 입력하세요" name="email">
				  <div id="forCheckAuthDiv"></div>
			      <input type="hidden" id="emailRegValid"/>
			      <input type="hidden" id="emailValid"/>
				  <button class="btn btn-success check-btn" id="emailDupCheckBtn">이메일 중복확인</button>
				  <button class="btn btn-primary check-btn" style="display: none;" id="sendEmail">인증메일 보내기</button>
			    </div>
				<div class="mb-3">
					<label for="memberName">이름 : </label><span></span>
					<input type="text" class="form-control" id="memberName" placeholder="이름을 입력하세요" name="memberName" >
				</div>		    
			    
			    <button type="submit" class="btn btn-primary" onclick="return isValid();">가입</button>
			    <button type="reset" class="btn btn-danger" onclick="resetForm();">취소</button>
				<div></div>
				<div id="forSignUpError"></div>
			</form>
			
		</div>
	</div>
	<jsp:include page="../footer.jsp"></jsp:include>
</body>
</html>