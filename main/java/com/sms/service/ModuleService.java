package com.sms.service;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import java.util.*;

@Service
public class ModuleService {
    public record Field(String key, String label, String type, boolean required) {}
    public record Module(String key, String title, String singular, String table, List<Field> fields) {}

    private final JdbcTemplate jdbc;
    private final Map<String, Module> modules = new LinkedHashMap<>();

    public ModuleService(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
        add("students","Students","Student","sms_students",
            f("registration_number","Registration number","text",true),
            f("full_name","Full name","text",true), f("email","Email address","email",true),
            f("phone","Phone number","text",false), f("department","Department","text",false),
            f("programme","Programme / course","text",false), f("year_of_study","Year of study","select",false),
            f("status","Status","select",true));
        add("departments","Departments","Department","sms_departments",
            f("department_code","Department code","text",true), f("department_name","Department name","text",true),
            f("description","Description","text",false), f("head_of_department","Head of department","text",false));
        add("courses","Courses","Course","sms_courses",
            f("course_code","Course code","text",true), f("course_name","Course name","text",true),
            f("department","Department","text",false), f("duration","Duration","text",false),
            f("programme_level","Programme level","select",false));
        add("teachers","Teachers","Teacher","sms_teachers",
            f("employee_id","Employee ID","text",true), f("full_name","Full name","text",true),
            f("email","Email address","email",true), f("department","Department","text",false),
            f("specialization","Specialization","text",false), f("phone","Phone number","text",false));
        add("subjects","Subjects","Subject","sms_subjects",
            f("subject_code","Subject code","text",true), f("subject_name","Subject name","text",true),
            f("course","Course","text",false), f("semester","Semester","text",false),
            f("credits","Credits","number",false));
        add("attendance","Attendance","Attendance record","sms_attendance",
            f("registration_number","Student registration number","text",true), f("subject_code","Subject code","text",false),
            f("attendance_date","Date (YYYY-MM-DD)","date",true), f("attendance_status","Attendance status","select",true),
            f("remarks","Remarks","text",false));
        add("examinations","Examinations","Examination","sms_examinations",
            f("exam_name","Examination name","text",true), f("course","Course","text",false),
            f("subject_code","Subject code","text",false), f("exam_date","Examination date","date",false),
            f("maximum_marks","Maximum marks","number",false));
        add("marks","Marks & Results","Mark record","sms_marks",
            f("registration_number","Student registration number","text",true), f("subject_code","Subject code","text",true),
            f("exam_name","Examination","text",false), f("marks_obtained","Marks obtained","number",true),
            f("maximum_marks","Maximum marks","number",true), f("grade","Grade","text",false));
        add("fees","Student Fees","Fee record","sms_fees",
            f("registration_number","Student registration number","text",true), f("fee_type","Fee type","text",true),
            f("amount","Amount","number",true), f("due_date","Due date","date",false),
            f("payment_status","Payment status","select",true));
        add("announcements","Announcements","Announcement","sms_announcements",
            f("title","Title","text",true), f("message","Message","text",true),
            f("audience","Audience","text",false), f("publish_date","Publish date","date",false));
    }

    private Field f(String key,String label,String type,boolean required){return new Field(key,label,type,required);}
    private void add(String key,String title,String singular,String table,Field... fields){
        modules.put(key,new Module(key,title,singular,table,List.of(fields)));
    }
    public Collection<Module> all(){return modules.values();}
    public Module get(String key){return modules.get(key);}
    public List<Map<String,Object>> list(String key){
        Module m=require(key);
        return jdbc.queryForList("SELECT * FROM "+m.table()+" ORDER BY id DESC LIMIT 500");
    }
    public Map<String,Object> find(String key,long id){
        Module m=require(key);
        List<Map<String,Object>> rows=jdbc.queryForList("SELECT * FROM "+m.table()+" WHERE id=?",id);
        if(rows.isEmpty()) throw new NoSuchElementException("Record not found");
        return rows.get(0);
    }
    public void save(String key,Long id,Map<String,String> input){
        Module m=require(key);
        List<String> cols=new ArrayList<>(); List<Object> vals=new ArrayList<>();
        for(Field f:m.fields()){
            String value=input.getOrDefault(f.key(),"").trim();
            if(f.required() && value.isBlank()) throw new IllegalArgumentException(f.label()+" is required.");
            cols.add(f.key()); vals.add(value.isBlank()?null:value);
        }
        if(id==null){
            String placeholders=String.join(",",Collections.nCopies(cols.size(),"?"));
            jdbc.update("INSERT INTO "+m.table()+" ("+String.join(",",cols)+") VALUES ("+placeholders+")",vals.toArray());
        } else {
            String assignments=String.join(",",cols.stream().map(c->c+"=?").toList());
            vals.add(id);
            jdbc.update("UPDATE "+m.table()+" SET "+assignments+" WHERE id=?",vals.toArray());
        }
    }
    public void delete(String key,long id){Module m=require(key);jdbc.update("DELETE FROM "+m.table()+" WHERE id=?",id);}
    public long count(String key){Module m=require(key);Long n=jdbc.queryForObject("SELECT COUNT(*) FROM "+m.table(),Long.class);return n==null?0:n;}
    private Module require(String key){
        Module m=modules.get(key);
        if(m==null) throw new IllegalArgumentException("Unknown module: "+key);
        return m;
    }
}
