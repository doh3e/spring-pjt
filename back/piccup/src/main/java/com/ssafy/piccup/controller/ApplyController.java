package com.ssafy.piccup.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.piccup.model.dto.Apply;
import com.ssafy.piccup.model.service.ApplyService;

@RestController
public class ApplyController {
	private final ApplyService applyService;
	
	public ApplyController(ApplyService applyService) {
		this.applyService = applyService;
	}
	@GetMapping("/apply")
	public ResponseEntity<List<Apply>> read() {
		List<Apply> list = applyService.getApplyList();
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	@GetMapping("/apply/{apply_id}")
	public ResponseEntity<Apply> detail(@PathVariable("apply_id")int apply_id) {
		Apply apply = applyService.viewApply(apply_id);
		if (apply == null) return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
		return new ResponseEntity<>(apply, HttpStatus.OK);
	}
	@PostMapping("/apply")
	public ResponseEntity<?> create(@ModelAttribute Apply apply) {
		
		System.out.println(apply);
		applyService.addApply(apply);
		return new ResponseEntity<>(apply, HttpStatus.CREATED); 
	}
}
