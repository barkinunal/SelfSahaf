package com.example.accessingdatamysql.search.user_search;

import com.example.accessingdatamysql.models.User;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@Api(value = "user_search")
@RequestMapping("/user_search")
public class UserSearchController {

    @Autowired
    UserSearchService userSearchService;

    @ApiOperation("search user by name or surname")
    @GetMapping(path = "/searchUser")
    public @ResponseBody
    List<User> searchUser(@RequestParam("name") String name) {
        List<User> result = userSearchService.findUserByName(name);
        return result;
    }



}
