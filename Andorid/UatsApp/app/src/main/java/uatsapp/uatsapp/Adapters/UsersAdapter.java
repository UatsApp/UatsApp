package uatsapp.uatsapp.Adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;


import java.util.ArrayList;
import java.util.List;

import uatsapp.uatsapp.R;
import uatsapp.uatsapp.Utils.Users;

/**
 * Created by Sergiu on 7/9/2015.
 */
public class UsersAdapter extends ArrayAdapter<Users> {

    Context context;
    int res;
    private ArrayList<Users> dataSource;

    public UsersAdapter(Context context, int resource, List<Users> objects) {
        super(context, resource, objects);
        this.context =context;
        this.res = resource;
    }
    public void setDataSource(List<Users> dataSource) {
        this.dataSource = (ArrayList)dataSource;
        notifyDataSetChanged();
    }


    @Override
    public int getCount() {
        if (this.dataSource == null) {
            return 0;
        }
        return dataSource.size();
    }

    @Override
    public Users getItem(int position) {
        if (this.dataSource != null && this.dataSource.size() > position) {
            return dataSource.get(position);
        }
        return null;
    }


    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        final ViewHolder holder;
//            if (convertView == null) {
        LayoutInflater li = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        convertView = li.inflate(res, parent, false);
        holder = new ViewHolder();
        holder.name = (TextView) convertView.findViewById(R.id.tv_name);
        holder.length = (TextView) convertView.findViewById(R.id.tv_length);
        convertView.setTag(holder);

        final Users currentItem = getItem(position);
        String username = currentItem.getUsername();
        holder.name.setText(username);
        holder.length.setText(username);
        return convertView;
//        return super.getView(position, convertView, parent);
    }

    class ViewHolder {
        public ImageView iv_logo;
        public TextView name;
        public TextView length;
    }
}
