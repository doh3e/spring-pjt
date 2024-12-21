package com.ssafy.piccup.model.dto;

public class PersonalInfo {
	private int infoId;
	private int resumeId;
	private String username;
	private String birthDate;
	private String gender;
	private String email;
	private String homePhone;
	private String mobilePhone;
	private String address;
	private String addressDetail;
	private int postalCode;
//	private String profileImg;
	private String degree;
	private String hobby;
	private String specialty;
	
	public PersonalInfo() {
	}
	
	// 모든 필드 포함
	public PersonalInfo(int infoId, int resumeId, String username, String birthDate, String gender, String email,
			String homePhone, String mobilePhone, String address, String addressDetail, int postalCode, String degree,
			String hobby, String specialty) {
		this.infoId = infoId;
		this.resumeId = resumeId;
		this.username = username;
		this.birthDate = birthDate;
		this.gender = gender;
		this.email = email;
		this.homePhone = homePhone;
		this.mobilePhone = mobilePhone;
		this.address = address;
		this.addressDetail = addressDetail;
		this.postalCode = postalCode;
		this.degree = degree;
		this.hobby = hobby;
		this.specialty = specialty;
	}
	
	// username, birthDate, gender만 입력받는 생성자
	public PersonalInfo(int infoId, int resumeId, String username, String birthDate, String gender) {
		this.infoId = infoId;
		this.resumeId = resumeId;
		this.username = username;
		this.birthDate = birthDate;
		this.gender = gender;
	}

	public int getInfoId() {
		return infoId;
	}

	public void setInfoId(int infoId) {
		this.infoId = infoId;
	}

	public int getResumeId() {
		return resumeId;
	}

	public void setResumeId(int resumeId) {
		this.resumeId = resumeId;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getBirthDate() {
		return birthDate;
	}

	public void setBirthDate(String birthDate) {
		this.birthDate = birthDate;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getHomePhone() {
		return homePhone;
	}

	public void setHomePhone(String homePhone) {
		this.homePhone = homePhone;
	}

	public String getMobilePhone() {
		return mobilePhone;
	}

	public void setMobilePhone(String mobilePhone) {
		this.mobilePhone = mobilePhone;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getAddressDetail() {
		return addressDetail;
	}

	public void setAddressDetail(String addressDetail) {
		this.addressDetail = addressDetail;
	}

	public int getPostalCode() {
		return postalCode;
	}

	public void setPostalCode(int postalCode) {
		this.postalCode = postalCode;
	}

	public String getDegree() {
		return degree;
	}

	public void setDegree(String degree) {
		this.degree = degree;
	}

	public String getHobby() {
		return hobby;
	}

	public void setHobby(String hobby) {
		this.hobby = hobby;
	}

	public String getSpecialty() {
		return specialty;
	}

	public void setSpecialty(String specialty) {
		this.specialty = specialty;
	}	
	
}
