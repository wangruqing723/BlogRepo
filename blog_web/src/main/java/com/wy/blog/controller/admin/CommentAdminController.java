package com.wy.blog.controller.admin;

import com.wy.blog.pojo.Comment;
import com.wy.blog.pojo.PageBean;
import com.wy.blog.service.CommentService;
import com.wy.blog.utils.ResponseUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 管理员评论Controller层
 *
 * @author Administrator
 */
@Controller
@RequestMapping("/admin/comment")
public class CommentAdminController {

    @Autowired
    private CommentService commentService;

    /**
     * 分页查询评论信息
     *
     * @param page
     * @param rows
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping("/list")
    public String list(@RequestParam(value = "page", required = false, defaultValue = "1") String page,
                       @RequestParam(value = "limit", required = false, defaultValue = "10") String rows,
                       @RequestParam(value = "state", required = false) String state,
                       HttpServletResponse response) throws Exception {
        PageBean pageBean = new PageBean(Integer.parseInt(page), Integer.parseInt(rows));
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("start", pageBean.getStart());
        map.put("size", pageBean.getPageSize());
        map.put("state", state); // 评论状态
        List<Comment> commentList = commentService.list(map);
        System.out.println("打印commentList = " + commentList);
        Long total = commentService.getTotal(map);
        JSONObject result = new JSONObject();
        JsonConfig jsonConfig = new JsonConfig();
        jsonConfig.registerJsonValueProcessor(java.util.Date.class, new DateJsonValueProcessor("yyyy-MM-dd"));
        JSONArray jsonArray = JSONArray.fromObject(commentList, jsonConfig);
        System.out.println("打印commentList = " + commentList);
        result.put("data", jsonArray);
        result.put("count", total);
        result.put("code", 0);
        ResponseUtil.write(response, result);
        return null;
    }

    /**
     * 删除评论信息
     *
     * @param ids
     * @param response
     * @return
     * @throws Exception
     */
    @RequestMapping("/delete")
    public String delete(@RequestParam(value = "ids") String ids, HttpServletResponse response) throws Exception {
        String[] idsStr = ids.split(",");
        for (int i = 0; i < idsStr.length; i++) {
            commentService.delete(Integer.parseInt(idsStr[i]));
        }
        JSONObject result = new JSONObject();
        result.put("success", true);
        ResponseUtil.write(response, result);
        return null;
    }

    /**
     * @Description: 评论审核
     * @Param: [ids, state, response]
     * @return: java.lang.String
     * @Author: WY
     * @Date: 2020/2/25
     */
    @RequestMapping("/review")
    public String review(@RequestParam(value = "ids") String ids,
                         @RequestParam(value = "state") Integer state,
                         HttpServletResponse response) throws Exception {
        String[] idsStr = ids.split(",");
        for (int i = 0; i < idsStr.length; i++) {
            Comment comment = new Comment();
            comment.setState(state);
            comment.setId(Integer.parseInt(idsStr[i]));
            commentService.update(comment);
        }
        JSONObject result = new JSONObject();
        result.put("success", true);
        ResponseUtil.write(response, result);
        return null;
    }
}
