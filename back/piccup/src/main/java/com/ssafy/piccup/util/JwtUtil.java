package com.ssafy.piccup.util;

import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.Map;

import javax.crypto.SecretKey;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import io.jsonwebtoken.security.SignatureException;

@Component
public class JwtUtil {
	
	@Value("${jwt.salt}")
	private String salt;
	
	@Value("${jwt.access-token.expiretime}")
	private long accessTokenExpireTime;
	
	@Value("${jwt.refresh-token.expiretime}")
	private long refreshTokenExpireTime;
	
	public String createAccessToken(int userId, String email) {
		return create(userId, email, "access-token", accessTokenExpireTime); 
	}

	// AccessToken에 비해 유효기간을 길게 설정
	public String createRefreshToken(int userId, String email) {
		return create(userId, email, "refresh-token", refreshTokenExpireTime);
	}	
	
	// 키 생성
	private SecretKey generateKey() {
		return Keys.hmacShaKeyFor(salt.getBytes(StandardCharsets.UTF_8));
	}
	
	public boolean checkToken(String token) {
		
		try {
			// Json Web Signature : 서버에서 인증을 근거로 인증 정보를 서버의 private key 서명 한 것을 토큰화 한 것
			// setSigningKey: JWS 서명 검증을 위한 secret key 세팅
			// parseClaimsJws : 파싱하여 원본 jws 만들기

			Jws<Claims> claims = Jwts.parserBuilder()
                    .setSigningKey(this.generateKey()) // Signing key 설정
                    .build()
                    .parseClaimsJws(token); // JWT 파싱 및 검증
			
			// Claims는 Map 구현체 형태
//			log.debug("claims: {}", claims);
			return true; // 정상토큰
		} catch (ExpiredJwtException e) {
			    System.err.println("토큰이 만료되었습니다: " + e.getMessage());
		        throw e; // Exception을 던져서 Filter에서 처리
		} catch (SignatureException e) {
			System.out.println("잘못된 서명입니다.: " + e.getMessage());
			throw e;
		} catch (Exception e) {
			System.out.println("JWT 유틸 에러 발생: " + e.getMessage());
//			log.error(e.getMessage());
			throw e; // 비정상토큰
		}
	}
	
	/*
	 *  Token 발급
	 *  - key: Claim에 셋팅될 key값
	 *  - value: Claim에 셋팅될 data값
	 *  - subject: payload에 sub의 value로 들어갈 subject값
	 *  - expire: 토큰 유효기간 설정값
	 *  
	 *  jwt 토큰의 구성
	 *  - header / payload / signature
	 *  */
	private String create(int userId, String email, String subject, long expireTime) {
		// payloa설정
		// - 생성일 (IssuedAt), 유효기간 (Expiration), 토큰제목 (Subject), 데이터 (Claim)
		Claims claims = Jwts.claims()
				.setSubject(subject)
				.setIssuedAt(new Date())
				.setExpiration(new Date(System.currentTimeMillis() + expireTime));
		claims.put("email", email);
		claims.put("userId", userId);
		
		// 토큰생성
		String jwt = Jwts.builder()
		        .setHeaderParam("typ", "JWT") 						// 헤더 설정
		        .setClaims(claims) 									// 페이로드 설정
                .signWith(generateKey(), SignatureAlgorithm.HS256) 	// SecretKey 사용
		        .compact(); 										// JWT 직렬화
		
		return jwt;
	}
	
	// JWT에서 추출 - email 가져오기
	public String getUserEmail(String authorization) {
		Jws<Claims> claims  = null;
		try {
			claims = Jwts.parserBuilder().setSigningKey(this.generateKey()).build().parseClaimsJws(authorization);
		} catch (Exception e) {
//			log.error(e.getMessage());
//			throw new UnAuthorizedException();
			throw new SecurityException("Invalid JWT token");
		}
		Map<String, Object> value = claims.getBody();
//		log.info("value: {}", value);
		return (String) value.get("email");
	}
	
	// JWT에서 추출 - userId 가져오기
    public int getUserId(String authorization) {
		Jws<Claims> claims  = null;
		try {
			claims = Jwts.parserBuilder().setSigningKey(this.generateKey()).build().parseClaimsJws(authorization);
		} catch (Exception e) {
			throw new SecurityException("Invalid JWT token");
		}
		Map<String, Object> value = claims.getBody();
		return (int) value.get("userId");
	}

}