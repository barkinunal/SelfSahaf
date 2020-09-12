package com.example.accessingdatamysql;

import com.example.accessingdatamysql.dao.UserRepository;
import com.example.accessingdatamysql.models.User;
import com.google.common.hash.Hashing;
import org.junit.jupiter.api.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.junit4.SpringRunner;

import java.nio.charset.StandardCharsets;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

@RunWith(SpringRunner.class)
@DataJpaTest
public class UserRepositoryIntegrationTest {


    @Autowired
    private TestEntityManager entityManager;

    @Autowired
    private UserRepository userRepository;



    @Test
    public void whenFindByEmail_thenReturnUser(){

        String passSha;


        passSha = Hashing.sha256().hashString("12345", StandardCharsets.UTF_8).toString();

        User onur = new User("onur", passSha, "soyad","2020-20-20", "5555555", "abc@abc.mail");

        entityManager.persist(onur);
        entityManager.flush();


        Optional<User> found = userRepository.findUserByEmail(onur.getEmail());


        assertThat(found.get().getEmail()).isEqualTo(onur.getEmail());
    }
}
