package com.example.accessingdatamysql.controllers;

import com.example.accessingdatamysql.dao.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;


import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import javax.mail.*;
import javax.mail.internet.*;
import java.io.IOException;
import java.util.Date;
import java.util.Properties;


@Controller
@RequestMapping(path="/email")
@Api(value = "email", description = "All about mail")
public class EmailController {

    @Autowired
    private JavaMailSender javaMailSender;


    @Autowired
    private UserRepository userRepository;

    @ApiOperation("Send email to a user")
    @PostMapping(value = "/sendEmailToUser")
    public @ResponseBody String sendEmailToUser(String email, String title, String context){


        SimpleMailMessage msg = new SimpleMailMessage();
        msg.setFrom("selfsahaf.ss@gmail.com");
        msg.setTo(email);

        msg.setSubject(title);
        msg.setText(context);

        try{
            javaMailSender.send(msg);
        }
        catch(Exception e){
            return "Email could not be send.";
        }



        return "Email sent successfully";
    }




    @ApiOperation("Send email to a users")
    @PostMapping(value = "/sendEmailToUsers")
    public @ResponseBody String sendEmailToUsers(String title, String context) throws IOException, MessagingException {


        SimpleMailMessage msg = new SimpleMailMessage();
        msg.setSubject(title);
        msg.setText(context);

        Integer successfully = 0;
        Integer totalUsers = 0;

        Iterable<String> emails = userRepository.getUserEmails();

        for(String email : emails){

            try{
                msg.setFrom("selfsahaf.ss@gmail.com");
                msg.setTo(email);

                javaMailSender.send(msg);

                successfully += 1;
                totalUsers += 1;
            }
            catch(Exception e){
                totalUsers += 1;
            }

        }

        return "Emails sent to " + successfully.toString() + " of " + totalUsers.toString() + " users successfully";
    }









}