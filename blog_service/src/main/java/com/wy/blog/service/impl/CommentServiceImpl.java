package com.wy.blog.service.impl;

import com.wy.blog.dao.CommentDao;
import com.wy.blog.pojo.Comment;
import com.wy.blog.service.CommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * 评论Service实现类
 *
 * @author Administrator
 */
@Service("commentService")
public class CommentServiceImpl implements CommentService {

    @Autowired
    private CommentDao commentDao;

    public int add(Comment comment) {
        return commentDao.add(comment);
    }

    public List<Comment> list(Map<String, Object> map) {
        return commentDao.list(map);
    }

    public Long getTotal(Map<String, Object> map) {
        return commentDao.getTotal(map);
    }

    public Integer delete(Integer id) {
        return commentDao.delete(id);
    }

    public int update(Comment comment) {
        return commentDao.update(comment);
    }

}
