package com.wy.blog.controller.admin;

import com.wy.blog.pojo.Blog;
import com.wy.blog.pojo.BlogType;
import com.wy.blog.pojo.Blogger;
import com.wy.blog.pojo.Link;
import com.wy.blog.service.BlogService;
import com.wy.blog.service.BlogTypeService;
import com.wy.blog.service.BloggerService;
import com.wy.blog.service.LinkService;
import com.wy.blog.utils.ResponseUtil;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.support.RequestContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * ???????Controller??
 *
 * @author Administrator
 */
@Controller
@RequestMapping("/admin/system")
public class SystemAdminController {

    @Autowired
    private BloggerService bloggerService;

    @Autowired
    private BlogTypeService blogTypeService;

    @Autowired
    private BlogService blogService;

    @Autowired
    private LinkService linkService;

    @RequestMapping("/main")
    public String main() {
        System.out.println("跳到首页...123");
        return "admin/main";
    }

    /**
     * ?????????
     *
     * @param request
     * @return
     * @throws Exception
     */
    @RequestMapping("/refreshSystem")
    public String refreshSystem(HttpServletResponse response, HttpServletRequest request) throws Exception {
        ServletContext application = RequestContextUtils.findWebApplicationContext(request).getServletContext();
        Blogger blogger = bloggerService.find(); // ??????????
        blogger.setPassword(null);
        application.setAttribute("blogger", blogger);

        List<BlogType> blogTypeCountList = blogTypeService.countList(); // ??????????????????????
        application.setAttribute("blogTypeCountList", blogTypeCountList);

        List<Blog> blogCountList = blogService.countList(); // ?????????????????
        application.setAttribute("blogCountList", blogCountList);

        List<Link> linkList = linkService.list(null); // ???????????????
        application.setAttribute("linkList", linkList);

        JSONObject result = new JSONObject();
        result.put("success", true);
        ResponseUtil.write(response, result);
        return null;
    }
}
