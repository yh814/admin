package com.example.admin.dto;

import lombok.Data;
import org.apache.ibatis.type.Alias;

@Data
@Alias("PageDto")
public class PageDto {

    // 최소 페이지 번호
    private int min;
    // 최대 페이지 번호
    private int max;
    // 이전 버튼의 페이지 번호
    private int prevPage;
    // 다음 버튼의 페이지 번호
    private int nextPage;
    // 전체 페이지 개수
    private int pageCnt;
    // 현재 페이지 번호
    private int currentPage;
    // 페이지 버튼의 개수(property)
    private int paginationCnt;

    // contentCnt : 전체글 개수(table), currentPage : 현재 페이지 번호(param), contentPageCnt : 페이지당 글의 개수(property)
    public PageDto(int contentCnt, int currentPage, int contentPageCnt) {

        // 현재 페이지 번호
        this.currentPage = currentPage;
        this.pageCnt = (int) Math.ceil((double) contentCnt / contentPageCnt);

        // 페이지 버튼 개수 동적 계산
        if (pageCnt <= 5) {
            this.paginationCnt = pageCnt;
        } else if (pageCnt <= 10) {
            this.paginationCnt = 7; // 전체 페이지 수가 10 이하이면 최대 7개의 페이지 번호 표시
        } else {
            this.paginationCnt = 10; // 그 외의 경우는 최대 10개의 페이지 번호 표시
        }

        // 최소 페이지 번호와 최대 페이지 번호 계산
        this.min = ((currentPage - 1) / paginationCnt) * paginationCnt + 1;
        this.max = Math.min(min + paginationCnt - 1, pageCnt);

        // 이전 페이지와 다음 페이지 번호 계산
        this.prevPage = Math.max(min - 1, 1);
        this.nextPage = Math.min(max + 1, pageCnt);
    }
}
