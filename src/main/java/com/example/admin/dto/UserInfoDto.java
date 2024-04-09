package com.example.admin.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;
import lombok.ToString;
import org.apache.ibatis.type.Alias;
import org.springframework.web.multipart.MultipartFile;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.List;
@ToString
@Data
@Alias("UserInfoDto")
public class UserInfoDto implements Serializable {

    private int userNum;

    @Size(min = 2, max = 10)
    @Pattern(regexp = "^[a-zA-Zㄱ-ㅎ가-힣]*$")
    @NotBlank
    private String userName;

    @Size(min = 5, max = 20)
    @Pattern(regexp = "^[a-z0-9_-]+$")
    @NotBlank
    private String userId;

    @Size(min = 8, max = 16)
    @Pattern(regexp = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]*$")
    @NotBlank
    private String userPw;

    @NotBlank
    private String userPw2;

    @Pattern(regexp = "^\\d{2,3}-\\d{3,4}-\\d{4}$")
    @NotBlank
    private String userPhone;

    @Pattern(regexp = "^\\d{4}-\\d{2}-\\d{2}$")
    @NotBlank
    private String userBirth;

    @NotBlank
    private String addr;

    private String addrDetail;

    @Pattern(regexp = "^\\d{4}-\\d{2}-\\d{2}$")
    @NotBlank
    private String startDate;

    @Pattern(regexp = "^\\d+$")
    @NotBlank
    private String salary;

    @NotBlank
    private String sexCD;

    @NotBlank
    private String userStatusCD;

    @NotBlank
    private String userRankCD;

    @NotBlank
    private String userGradeCD;

    @NotBlank
    private String conStatusCD;

    private String userEmail;

    private String userEmail2;

    @JsonIgnore
    private MultipartFile userImgFile;
    private String userImg;

    private String role;

    private boolean userIdExist;
    private boolean userLogin;

    public UserInfoDto() {
        this.userIdExist = false;
        this.userLogin = false;
    }

    private List<String> skillCD;

    //코드마스터 detailName
    private String genderDetailName; // 성별 상세 이름
    private String employmentStatusDetailName; // 재직 상태 상세 이름
    private String rankDetailName; // 직급 상세 이름
    private String gradeDetailName; // 기술 등급 상세 이름
    private String contractStatusDetailName; // 계약 상태 상세 이름
    private String emailDetailName; //이메일 상세 이름

    private List<String> skillDetailNameList; //스킬 상세 이름

    private String skillDetailName;//search에서 사용


    public UserInfoDto(String username, String password, String role) {
    }
}
