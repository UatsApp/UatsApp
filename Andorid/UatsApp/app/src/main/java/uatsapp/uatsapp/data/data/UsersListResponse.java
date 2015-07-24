package uatsapp.uatsapp.data.data;

import java.util.List;

import uatsapp.uatsapp.Utils.User;

/**
 * Created by Vlad on 21-Jul-15.
 */
public class UsersListResponse extends BaseResponse{
    List<User> users;
    public List<User> getUsers() {return users;}
    public void setUsers(List<User> users) {this.users = users;}
}
