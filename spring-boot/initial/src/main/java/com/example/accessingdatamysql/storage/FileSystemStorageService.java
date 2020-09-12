package com.example.accessingdatamysql.storage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.util.FileSystemUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.PostConstruct;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Stream;

@Service
public class FileSystemStorageService implements StorageService {
    static final String[] EXTENSIONS = new String[]{
            "gif", "png", "bmp", "jpg" // and other formats you need
    };

    static final String EXTENSION = ".png";

    private final Path rootLocation;

    @Autowired
    public FileSystemStorageService(StorageProperties properties) {
        this.rootLocation = Paths.get(properties.getLocation());
    }

    @Override
    @PostConstruct
    public void init() {
        try
        {
            File dir = new File(rootLocation.toAbsolutePath().toString());
            if(!dir.exists())
                dir.mkdirs();
        }
        catch (Exception e)
        {
            throw new StorageException("Can't make directory",e);
        }

    }



    @Override
    public String store(MultipartFile file,String filename) {
        try {
            if (file.isEmpty()) {
                throw new StorageException("Failed to store empty file " + filename);
            }
            if (filename.contains("..")) {
                throw new StorageException(
                        "Cannot store file with relative path outside current directory "
                                + filename);
            }
            try (InputStream inputStream = file.getInputStream()) {

                System.out.println(this.rootLocation);
                Files.copy(inputStream, this.rootLocation.resolve(filename).toAbsolutePath(),
                        StandardCopyOption.REPLACE_EXISTING);
            }

        }
        catch (IOException e) {
            throw new StorageException("Failed to store file " + this.rootLocation.resolve(filename).toAbsolutePath(), e);
        }

        return filename;
    }


    @Override
    public Stream<Path> loadAll() {
        try {
            return Files.walk(this.rootLocation, 1)
                    .filter(path -> !path.equals(this.rootLocation))
                    .map(this.rootLocation::relativize);
        }
        catch (IOException e) {
            throw new StorageException("Failed to read stored files", e);
        }

    }

    @Override
    public Path load(String filename) {
        return rootLocation.resolve(filename);
    }

    @Override
    public Resource loadAsResource(String filename) {
        try {
//            Path file = load(filename);
            Path file = Paths.get(filename);
            Resource resource = new UrlResource(file.toUri());
            if (resource.exists() || resource.isReadable()) {
                return resource;
            }
            else {
                throw new FileNotFoundException(
                        "Could not read file: " + filename);
            }
        }
        catch (MalformedURLException e) {
            throw new FileNotFoundException("Could not read file: " + filename, e);
        }
    }

    @Override
    public String storeAll(List<MultipartFile> files, Integer productID){

        Path dir_path = Paths.get("productImages").resolve(Paths.get(productID.toString()));

        return storeAllIns(dir_path, files);


    }

    private String storeAllIns(Path dir_path, List<MultipartFile> files)
    {
        // Create a directory in the format of root/sellerID/productID

        try
        {
            File dir = new File(this.rootLocation.resolve(dir_path.toString()).toString());
            if(!dir.exists())
                dir.mkdirs();
        }
        catch (Exception e)
        {
            throw new StorageException("Can't make directory",e);
        }
        Integer enumerate = 1;


        for (MultipartFile file :  files)
        {

            this.store(file, dir_path.resolve(enumerate.toString() + EXTENSION).toString());


            enumerate += 1;
        }
        return this.rootLocation.resolve(dir_path.toString()).toAbsolutePath().toString();
    }

    @Override
    public String storeAllRefund(List<MultipartFile> files, Integer refundID)
    {
        Path dir_path = Paths.get("refunds").resolve(refundID.toString());
        return storeAllIns(dir_path, files);
    }

    @Override

    public String storeMain(MultipartFile file, Integer productID){

        Path dir_path = Paths.get(productID.toString());


        // Create a directory in the format of root/sellerID/productID
        try
        {
            File dir = new File(this.rootLocation.resolve("productImages"+dir_path.toString()).toString());
            boolean isCreated = dir.mkdirs();
        }
        catch (Exception e)
        {
            System.out.println("Directory already exists");
        }
        Integer enumerate = 1;



        this.store(file, dir_path.resolve("main" + EXTENSION).toString());

        return dir_path.toString();

    }

    @Override
    public void deleteAll() {
        FileSystemUtils.deleteRecursively(rootLocation.toFile());
    }

    @Override
    public List<Resource> loadAllResources(String productID){
        Path root = this.rootLocation.resolve("productImages");

        File folder = new File(root.resolve(productID.toString()).toString());

        File[] listOfFiles = folder.listFiles();
        List<Resource> resourceList = new ArrayList<Resource>();

        for (File file : listOfFiles) {
            if (acceptExtension(file)) {
                resourceList.add(loadAsResource(file.toString()));
            }
        }

        return resourceList;
    }

    @Override
    public List<Resource> loadAllResourcesRefund(String refundID){
        Path root = this.rootLocation.resolve("refunds");

        File folder = new File(root.resolve(refundID.toString()).toString());

        File[] listOfFiles = folder.listFiles();
        List<Resource> resourceList = new ArrayList<Resource>();

        for (File file : listOfFiles) {
            if (acceptExtension(file)) {
                resourceList.add(loadAsResource(file.toString()));
            }
        }

        return resourceList;
    }

    public boolean acceptExtension(final File dir) {

        String name = dir.toString();

        for (final String ext : EXTENSIONS) {
            if (name.endsWith("." + ext)) {
                return (true);
            }
        }
        return (false);
    }
}