package com.example.ecsspringboot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.example.ecsspringboot.model.Book;
import com.example.ecsspringboot.service.BookService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class BookController {

  @Autowired
  private BookService bookService;

  @GetMapping("/hello")
  public String getHello(Model model) {
    log.info("Hello page requested");
    
    model.addAttribute("name","홍길동");
    model.addAttribute("company","<b>Github</b>");
    model.addAttribute("person",false);
    return "hello";
  }

  /**
   * 기본 도서 상세 페이지 (ID 없이 접근할 때)
   * 첫 번째 도서(ID: 0)를 기본으로 표시
   */
  @GetMapping("/book")
  public String getBook(Model model) {
    log.info("Default book page requested");
    return getBookById(0L, model);
  }

  /**
   * 특정 도서 ID로 상세 페이지 접근
   * @param id 도서 ID
   * @param model Spring Model 객체
   * @return book.mustache 템플릿
   */
  @GetMapping("/book/{id}")
  public String getBookById(@PathVariable Long id, Model model) {
    log.info("Book detail page requested for ID: {}", id);
    
    Book book = bookService.getBookById(id);
    
    if (book != null) {
      model.addAttribute("book", book);
      log.info("Book found: {}", book.getBookTitle());
    } else {
      // 존재하지 않는 도서 ID인 경우 기본 도서 표시
      book = bookService.getBookById(0L);
      model.addAttribute("book", book);
      model.addAttribute("error", "요청하신 도서(ID: " + id + ")를 찾을 수 없어 기본 도서를 표시합니다.");
      log.warn("Book with ID {} not found, showing default book", id);
    }
    
    return "book";
  }

  /**
   * 도서 목록 페이지
   * @param model Spring Model 객체
   * @return bookList.mustache 템플릿
   */
  @GetMapping("/books")
  public String getBooks(Model model) {
    log.info("Book list page requested");
    
    try {
      var bookList = bookService.getAllBooks();
      model.addAttribute("bookList", bookList);
      
      // 추가 통계 정보
      model.addAttribute("totalCount", bookService.getTotalBookCount());
      
      log.info("Successfully loaded {} books", bookList.size());
    } catch (Exception e) {
      log.error("Error loading book list: ", e);
      model.addAttribute("error", "도서 목록을 불러오는 중 오류가 발생했습니다.");
    }
    
    return "bookList";
  }

}
