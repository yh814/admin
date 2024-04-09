package com.example.admin.controller;

import com.example.admin.dao.BoardDao;
import com.example.admin.dto.BoardDto;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/board")
public class BoardController {

    private final BoardDao boardDao;

    public BoardController(BoardDao boardDao) {
        this.boardDao = boardDao;
    }

    @GetMapping("/homePage")
    public String homePage(Model model) {
        // 공지사항 목록을 가져오는 코드
        List<BoardDto> noticeList = boardDao.getNotice();
        model.addAttribute("noticeList", noticeList);

        List<BoardDto> freeBoardList = boardDao.getFreeBoard();
        model.addAttribute("freeBoardList", freeBoardList);

        return "board/homePage";
    }

    @GetMapping("/notice")
    public String getAllNotice(Model model) {
        List<BoardDto> allNotice = boardDao.getMainNotice();
        model.addAttribute("allNotice", allNotice);
        return "board/notice";
    }

    @GetMapping("/freeBoard")
    public String getAllFreeBoard(@RequestParam(value="searchContents", required = false)String searchContents,
                                  @RequestParam(value="searchTitle", required = false)String searchTitle,
                                  @RequestParam(value="searchUserId", required = false)String searchUserId, Model model) {

        List<BoardDto> allFreeBoard = boardDao.getMainFreeBoard(searchContents, searchTitle, searchUserId);
        model.addAttribute("allFreeBoard", allFreeBoard);

        return "board/freeBoard";
    }
}
