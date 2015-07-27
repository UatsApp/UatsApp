package uatsapp.uatsapp.Adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.CheckBox;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import uatsapp.uatsapp.AppPreferences;
import uatsapp.uatsapp.R;
import uatsapp.uatsapp.Utils.User;
import uatsapp.uatsapp.data.data.MessageHistory;

/**
 * Created by Vlad on 22-Jul-15.
 */
public class HistoryAdapter extends ArrayAdapter<MessageHistory>{

//    Context context;
//    int res;
//    private ArrayList<MessageHistory> dataSource;
//
//    public HistoryAdapter(Context context, int resource, List<MessageHistory> objects) {
//        super(context, resource, objects);
//        this.context =context;
//        this.res = resource;
//    }
//    public void setDataSource(List<MessageHistory> dataSource) {
//        this.dataSource = (ArrayList)dataSource;
//        notifyDataSetChanged();
//    }
//
//
//    @Override
//    public int getCount() {
//        if (this.dataSource == null) {
//            return 0;
//        }
//        return dataSource.size();
//    }
//
//    @Override
//    public MessageHistory getItem(int position) {
//        if (this.dataSource != null && this.dataSource.size() > position) {
//            return dataSource.get(position);
//        }
//        return null;
//    }
//
//
//    @Override
//    public View getView(int position, View convertView, ViewGroup parent) {
//
//        final ViewHolder holder;
////            if (convertView == null) {
//        LayoutInflater li = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
//        convertView = li.inflate(res, parent, false);
//        holder = new ViewHolder();
//        holder.name = (TextView) convertView.findViewById(R.id.tv_name);
//        holder.length = (TextView) convertView.findViewById(R.id.tv_length);
//        convertView.setTag(holder);
//
//        String message; //currentItem.getMessage();
//        final MessageHistory currentItem = getItem(position);
//        int userId = currentItem.get_from();
//        if(userId==AppPreferences.getIntPreferences("friendId"))
//            holder.name.setText(AppPreferences.getStringPreferences("friendUser")+": ");
//        else
//            holder.name.setText("You: ");
//        message=currentItem.getMessage();
//        holder.length.setText(message);
//        return convertView;
//
////        return super.getView(position, convertView, parent);
//    }
//
//    class ViewHolder {
//        public ImageView iv_logo;
//        public TextView name;
//        public TextView length;
//    }






    Context context;
    int res;
    LayoutInflater inflater;
    private ArrayList<MessageHistory> dataSource;

    private static final int TYPES_COUNT = 2;
    private static final int TYPE_LEFT = 0;
    private static final int TYPE_RIGHT = 1;

    public HistoryAdapter(Context context, int resource, List<MessageHistory> objects) {
        super(context, resource, objects);
        this.context =context;
        this.res = resource;
    }

    @Override
    public int getViewTypeCount() {
        return TYPES_COUNT;
    }

    @Override
    public int getCount() {
        if (this.dataSource == null) {
            return 0;
        }
        return dataSource.size();
    }

    public void setDataSource(List<MessageHistory> dataSource) {
        this.dataSource = (ArrayList)dataSource;
        notifyDataSetChanged();
    }

    @Override
    public MessageHistory getItem(int position) {
        if(dataSource != null && !dataSource.isEmpty() && dataSource.size() > position)
            return dataSource.get(position);
        else
            return null;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View row = convertView;
        Holder holder;
        MessageHistory coment = getItem(position);

        if (row == null) {
            holder = new Holder();

        int userId = coment.get_from();

            LayoutInflater li = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            if(userId==AppPreferences.getIntPreferences("friendId")){
                row = li.inflate(R.layout.listitem_left_chat, parent, false);
                holder.message = (TextView) row.findViewById(R.id.message2);
                holder.message.setText(coment.getMessage());
                holder.userName = (TextView) row.findViewById(R.id.message);
                holder.userName.setText(AppPreferences.getStringPreferences("friendUser"));
            } else {
                row = li.inflate(R.layout.listitem_right_chat, parent, false);
                holder.message = (TextView) row.findViewById(R.id.message2);
                holder.message.setText(coment.getMessage());
                holder.userName = (TextView) row.findViewById(R.id.message);
                holder.userName.setText("You");
            }
            row.setTag(holder);
        }

        return row;
    }

    public class Holder {
        TextView userName;
        TextView message;
    }



}
