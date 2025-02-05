package com.ssafy.piccup.model.service.user;

import java.util.List;

import com.ssafy.piccup.model.dto.user.User;

public interface UserService {
	// 전체 사용자 목록 가져오기
	public List<User> getUserList();
	
	// 특정 사용자 조회
	public User getUserInfo(int userId);
	
	// 회원가입
	public boolean signup(User user);

	// 회원 탈퇴
	public void deleteUser(String email);
	
	// 로그인
	public User login(String email, String password);

	// 로그아웃
	public boolean logout(String email);
	
	// 토큰저장
	public void saveRefreshToken(int userId, String refreshToken);
	
}
