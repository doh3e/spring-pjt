package com.ssafy.piccup.model.service.resume;

import java.util.List;

import com.ssafy.piccup.model.dto.resume.Skill;


public interface SkillService {
	
	// 스킬 전체 조회
    public List<Skill> readSkillList(int resumeId);

    // 스킬 추가
    public boolean createSkill(Skill skill);

    // 스킬 리스트 추가
    public void createSkillList(List<Skill> skills, int resumeId);

    // 스킬 수정
    public boolean updateSkill(Skill skill);

    // 스킬 삭제
    public boolean deleteSkill(int skillId);

}
