package com.example.test3.dto;

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

    // contentCnt : 전체글 개수(table), currentPage : 현재 페이지 번호(param), contentPageCnt : 페이지당 글의 개수(property), paginationCnt : 페이지 버튼의 개수(property)
    public PageDto(int contentCnt, int currentPage, int contentPageCnt, int paginationCnt) {

        // 현재 페이지 번호
        this.currentPage = currentPage;

        // 전체 페이지 개수
        pageCnt = contentCnt / contentPageCnt;

        if(contentCnt % contentPageCnt > 0) {
            pageCnt++;
        }

        min = ((currentPage - 1) / contentPageCnt) * contentPageCnt + 1;
        max = min + paginationCnt - 1;

        if(max > pageCnt) {
            max = pageCnt;
        }

        prevPage = min - 1;
        nextPage = max + 1;

        if(nextPage > pageCnt) {
            nextPage = pageCnt;
        }
    }
}
