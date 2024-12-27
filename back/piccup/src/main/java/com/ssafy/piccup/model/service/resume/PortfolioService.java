package com.ssafy.piccup.model.service.resume;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.ssafy.piccup.model.dto.resume.Portfolio;

public interface PortfolioService {
	
	// 포트폴리오 전체 조회 (resume기반)
    public List<Portfolio> readPortList(int resumeId);

    // 포트폴리오 추가
    public boolean createPort(Portfolio portfolio, MultipartFile file);

    // 포트폴리오 리스트 추가 - 파일별도
    public void createPortfolioList(List<Portfolio> portfolios, int resumeId);
    
    // 포트폴리오 수정
    public boolean updatePort(Portfolio portfolio, MultipartFile file);

    // 포트폴리오 삭제
    public boolean deletePort(int portId);
    
    // 포트폴리오 파일 추가
    public boolean uploadFile(Portfolio portfolio, MultipartFile file);

}
