package com.wy.blog.controller;

import com.wy.blog.pojo.Blog;
import com.wy.blog.pojo.Comment;
import com.wy.blog.service.BlogService;
import com.wy.blog.service.CommentService;
import com.wy.blog.utils.ResponseUtil;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 评论Controller层
 *
 * @author Administrator
 */
@Controller
@RequestMapping("/comment")
public class CommentController {

    @Autowired
    private CommentService commentService;

    @Autowired
    private BlogService blogService;

    /**
     * 添加或者修改评论
     *
     * @param comment
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping("/save")
    public String save(Comment comment, @RequestParam("imageCode") String imageCode,
                       HttpServletRequest request, HttpServletResponse response,
                       HttpSession session) throws Exception {
        String sRand = (String) session.getAttribute("sRand"); // 获取系统生成的验证码
        JSONObject result = new JSONObject();
        int resultTotal = 0; // 操作的记录条数
        if (!imageCode.equals(sRand)) {
            result.put("success", false);
            result.put("errorInfo", "验证码填写错误！");
        } else {
            String userIp = request.getRemoteAddr(); // 获取用户IP
            comment.setUserIp(userIp);
            if (comment.getId() == null) {
                resultTotal = commentService.add(comment);
                // 该博客的回复次数加1
                Blog blog = blogService.findById(comment.getBlog().getId());
                blog.setReplyHit(blog.getReplyHit() + 1);
                blogService.update(blog);
            } else {

            }
            if (resultTotal > 0) {
                result.put("success", true);
            } else {
                result.put("success", false);
            }
        }
        ResponseUtil.write(response, result);
        return null;
    }

}
