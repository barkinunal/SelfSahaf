package com.example.accessingdatamysql.Responses;

import com.example.accessingdatamysql.models.enums.ProductStatus;

public class CheckoutResponseItem {
    private String itemName;
    private Integer total;
    private Integer wanted;
    private ProductStatus status;

    private boolean flag = false;

    public CheckoutResponseItem(String itemName, Integer total, Integer wanted, ProductStatus active) {
        this.itemName = itemName;
        this.total = total;
        this.wanted = wanted;
        this.status = active;
    }

    @Override
    public String toString()
    {
        String rt = itemName + " is ok";
        if(status == ProductStatus.DEACTIVE){
            rt = itemName +" is not on sale anymore";
            flag = true;
        }
        else if(total < wanted){
            rt = "there is total "+ total.toString()+ " " + itemName + "on sale";
            flag = true;
        }
        return rt;
    }

    public boolean isFlag() {
        return flag;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
    }

    public Integer getWanted() {
        return wanted;
    }

    public void setWanted(Integer wanted) {
        this.wanted = wanted;
    }

    public ProductStatus getStatus() {
        return status;
    }

    public void setStatus(ProductStatus status) {
        this.status = status;
    }
}

