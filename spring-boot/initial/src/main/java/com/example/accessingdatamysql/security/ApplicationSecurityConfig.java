package com.example.accessingdatamysql.security;

import com.example.accessingdatamysql.auth.UserDetailsImp;
import com.example.accessingdatamysql.auth.UserDetailsServiceImp;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.Http403ForbiddenEntryPoint;
import org.springframework.security.web.authentication.HttpStatusEntryPoint;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.concurrent.TimeUnit;

import static com.example.accessingdatamysql.security.UserRole.*;

@Configuration
@EnableWebSecurity
public class ApplicationSecurityConfig extends WebSecurityConfigurerAdapter {

    private final PasswordEncoder passwordEncoder;
    private final UserDetailsServiceImp userDetailsServiceImp;

    @Autowired
    public ApplicationSecurityConfig(PasswordEncoder passwordEncoder,
                                     UserDetailsServiceImp userDetailsServiceImp) {
        this.passwordEncoder = passwordEncoder;
        this.userDetailsServiceImp = userDetailsServiceImp;

    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.authenticationProvider(daoAuthenticationProvider());
    }

    public DaoAuthenticationProvider daoAuthenticationProvider() {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setPasswordEncoder(passwordEncoder);
        provider.setUserDetailsService(userDetailsServiceImp);
        return provider;
    }

    @Bean
    public AuthenticationFailureHandler authenticationFailureHandler() {
        return new AuthenticationFailiureHandlerImp();
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {

        http
                .csrf().disable()
                .authorizeRequests()
                    .antMatchers("/").permitAll()
                    .antMatchers("/login").hasAnyRole(ANON.name())
                    .antMatchers("/swagger-ui.html/**").hasAnyRole(ADMIN.name(), SELLER.name(), USER.name())
                     // USER CONTROLLERS
                    .antMatchers("/user/add").permitAll()
                    .antMatchers("/user/update").hasAnyRole(ADMIN.name(), SELLER.name(), USER.name())
                    .antMatchers("/user/get").hasAnyRole(ADMIN.name(), SELLER.name(), USER.name())
                    .antMatchers("/user/all").hasAnyRole(ADMIN.name())
                    .antMatchers("/user/addSellerAddress").hasAnyRole(ADMIN.name(), SELLER.name(), USER.name())
                    .antMatchers("/user/addAddress").hasAnyRole(ADMIN.name(), SELLER.name(), USER.name())
                    .antMatchers("/user/getAddress").hasAnyRole(ADMIN.name(), SELLER.name(), USER.name())
                    .antMatchers("/user/getSellerAddress").hasAnyRole(ADMIN.name(), SELLER.name(), USER.name())
                    .antMatchers("/user/getSells").hasAnyRole(ADMIN.name(), SELLER.name(), USER.name())
                    // PRODUCT CONTROLLERS
                    .antMatchers("/product/getBooks").hasAnyRole(ADMIN.name(), SELLER.name())
                    .antMatchers("/product/updateBook").hasAnyRole(ADMIN.name(), SELLER.name())
                    .antMatchers("/product/deleteBook").hasAnyRole(ADMIN.name(), SELLER.name())
                    .antMatchers("/product/addCategory").hasAnyRole(ADMIN.name())
                    .antMatchers("/product/getCategories").permitAll()
                    .antMatchers("/product/getBooks").permitAll()
                    .antMatchers("/product/getSellerBooks").permitAll()
                    .antMatchers("/product/getSelfBooks").hasAnyRole(ADMIN.name(), SELLER.name())
                    .antMatchers("/**").permitAll()
                .anyRequest().authenticated()
                .and()
                .formLogin()
                    .loginPage("/login").permitAll()
                    .defaultSuccessUrl("/product/getBooks", true)
                    .passwordParameter("password")
                    .usernameParameter("email")
                    .failureHandler(authenticationFailureHandler())
                .and()
                .rememberMe()
                    .tokenValiditySeconds((int) TimeUnit.DAYS.toSeconds(21))
                    .key("somethingverysecured")
                    .rememberMeParameter("remember-me")
                    .alwaysRemember(true)
                .and()
                .anonymous()
                    .authorities(ANON.name())
                .and()
                    .exceptionHandling()
                    .authenticationEntryPoint(new HttpStatusEntryPoint(HttpStatus.NOT_ACCEPTABLE))
                .and()
                .logout()
                    .logoutUrl("/logout")
                    .logoutRequestMatcher(new AntPathRequestMatcher("/logout", "GET"))
                    .clearAuthentication(true)
                    .invalidateHttpSession(true)
                    .deleteCookies("JSESSIONID", "remember-me")
                    .logoutSuccessUrl("/login");
    }


}
