package com.example.ecsspringboot.service;

import java.util.List;
import java.util.ArrayList;

import org.springframework.stereotype.Service;

import com.example.ecsspringboot.model.Book;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class BookService {

    /**
     * 모든 도서 목록을 조회합니다.
     * @return 도서 목록
     */
    public List<Book> getAllBooks() {
        log.info("Fetching all books from service");
        return createBookList();
    }

    /**
     * 특정 ID의 도서를 조회합니다.
     * @param id 도서 ID
     * @return 해당 ID의 도서, 없으면 null
     */
    public Book getBookById(Long id) {
        log.info("Fetching book with ID: {}", id);
        return findBookById(id);
    }

    /**
     * 도서가 존재하는지 확인합니다.
     * @param id 도서 ID
     * @return 존재하면 true, 없으면 false
     */
    public boolean existsById(Long id) {
        return findBookById(id) != null;
    }

    /**
     * 전체 도서 수를 반환합니다.
     * @return 도서 수
     */
    public int getTotalBookCount() {
        return createBookList().size();
    }

    /**
     * 도서 목록을 생성하는 private 메소드
     * 실제 환경에서는 데이터베이스에서 조회하겠지만, 
     * 현재는 하드코딩된 데이터를 사용합니다.
     */
    private List<Book> createBookList() {
        List<Book> bookList = new ArrayList<Book>();
        
        // 실제 도서 데이터로 구성
        String[] titles = {
            "Spring Boot 완벽 가이드",
            "Java 프로그래밍 입문",
            "웹 개발 마스터 클래스",
            "데이터베이스 설계와 구현",
            "클린 코드: 애자일 소프트웨어 장인 정신"
        };
        
        String[] authors = {
            "김개발",
            "이자바",
            "박웹개발",
            "최데이터",
            "정클린코드"
        };
        
        String[] isbns = {
            "978-89-123-4567-8",
            "978-89-234-5678-9", 
            "978-89-345-6789-0",
            "978-89-456-7890-1",
            "978-89-567-8901-2"
        };

        for(int i = 0; i < 5; i++){
            Book book = new Book(
                (long) i,
                (i < 3) ? true : false,  // 처음 3개 도서는 ISBN 있음
                titles[i],
                authors[i],
                (double) (15000 + (i * 3000))  // 15,000원부터 3,000원씩 증가
            );
            
            bookList.add(book);
        }

        return bookList;
    }

    /**
     * ID로 특정 도서를 찾는 private 메소드
     */
    private Book findBookById(Long id) {
        List<Book> bookList = createBookList();
        
        for (Book book : bookList) {
            if (book.getBookid() == id.longValue()) {
                return book;
            }
        }
        return null;  // 찾지 못한 경우
    }
}
