package org.zerock.controller;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardVO_BSR;
import org.zerock.domain.PageMaker_BSR;
import org.zerock.domain.SearchCriteria_BSR;
import org.zerock.service.BoardService_BSR;

@Controller
@RequestMapping("/tboard/*")
public class SearchBoardController_BSR {

  private static final Logger logger = LoggerFactory.getLogger(SearchBoardController_BSR.class);

  @Inject
  private BoardService_BSR service;

  @RequestMapping(value = "/list", method = RequestMethod.GET)
  public void listPage(@ModelAttribute("cri") SearchCriteria_BSR cri, Model model) throws Exception {

    logger.info(cri.toString());

    // model.addAttribute("list", service.listCriteria(cri));
    model.addAttribute("list", service.listSearchCriteria(cri));

    PageMaker_BSR pageMaker = new PageMaker_BSR();
    pageMaker.setCri(cri);

    // pageMaker.setTotalCount(service.listCountCriteria(cri));
    pageMaker.setTotalCount(service.listSearchCount(cri));

    model.addAttribute("pageMaker", pageMaker);
  }

  @RequestMapping(value = "/readPage", method = RequestMethod.GET)
  public void read(@RequestParam("bno") int bno, @ModelAttribute("cri") SearchCriteria_BSR cri, Model model)
      throws Exception {

    model.addAttribute(service.read(bno));
  }

  @RequestMapping(value = "/removePage", method = RequestMethod.POST)
  public String remove(@RequestParam("bno") int bno, SearchCriteria_BSR cri, RedirectAttributes rttr) throws Exception {

    service.remove(bno);

    rttr.addAttribute("board_id", cri.getBoard_id());
    rttr.addAttribute("page", cri.getPage());
    rttr.addAttribute("perPageNum", cri.getPerPageNum());
    rttr.addAttribute("searchType", cri.getSearchType());
    rttr.addAttribute("keyword", cri.getKeyword());

    rttr.addFlashAttribute("msg", "SUCCESS");

    return "redirect:/tboard/list";
  }

  @RequestMapping(value = "/modifyPage", method = RequestMethod.GET)
  public void modifyPagingGET(int bno, @ModelAttribute("cri") SearchCriteria_BSR cri, Model model) throws Exception {

    model.addAttribute(service.read(bno));
  }

  @RequestMapping(value = "/modifyPage", method = RequestMethod.POST)
  public String modifyPagingPOST(BoardVO_BSR board, SearchCriteria_BSR cri, RedirectAttributes rttr) throws Exception {

    logger.info(cri.toString());
    service.modify(board);

    rttr.addAttribute("board_id", cri.getBoard_id());
    rttr.addAttribute("page", cri.getPage());
    rttr.addAttribute("perPageNum", cri.getPerPageNum());
    rttr.addAttribute("searchType", cri.getSearchType());
    rttr.addAttribute("keyword", cri.getKeyword());

    rttr.addFlashAttribute("msg", "SUCCESS");

    logger.info(rttr.toString());

    return "redirect:/tboard/list";
  }

  @RequestMapping(value = "/register", method = RequestMethod.GET)
  public void registGET(int board_id , Model model) throws Exception {
	//board_id 값을 파라메터로 전달 받아서 jsp페이지로 보냄
	model.addAttribute("board_id", board_id);
    logger.info("==============================register test=============================");
  }
  
  @RequestMapping(value = "/register", method = RequestMethod.POST)
  public String registPOST(BoardVO_BSR board, RedirectAttributes rttr) throws Exception {

    logger.info("regist post ...........");
    logger.info(board.toString());

    service.regist(board);

    rttr.addFlashAttribute("msg", "SUCCESS");
    String rtnUrl = "redirect:/tboard/list?board_id=" + board.getBoard_id();
    return rtnUrl;
  }
  
  
  @RequestMapping("/getAttach/{bno}")
  @ResponseBody
  public List<String> getAttach(@PathVariable("bno")Integer bno)throws Exception{
    
    return service.getAttach(bno);
  }  

  // @RequestMapping(value = "/list", method = RequestMethod.GET)
  // public void listPage(@ModelAttribute("cri") SearchCriteria cri,
  // Model model) throws Exception {
  //
  // logger.info(cri.toString());
  //
  // model.addAttribute("list", service.listCriteria(cri));
  //
  // PageMaker pageMaker = new PageMaker();
  // pageMaker.setCri(cri);
  //
  // pageMaker.setTotalCount(service.listCountCriteria(cri));
  //
  // model.addAttribute("pageMaker", pageMaker);
  // }
}