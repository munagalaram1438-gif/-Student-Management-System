package com.sms.controller;

import com.sms.service.ModuleService;
import com.sms.service.ModuleService.Module;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.util.*;

@Controller
public class WebController {
    private final ModuleService service;
    public WebController(ModuleService service){this.service=service;}

    @GetMapping("/")
    public String dashboard(Model model){
        model.addAttribute("modules",service.all());
        model.addAttribute("studentCount",service.count("students"));
        model.addAttribute("departmentCount",service.count("departments"));
        model.addAttribute("courseCount",service.count("courses"));
        model.addAttribute("teacherCount",service.count("teachers"));
        model.addAttribute("recent",service.list("students").stream().limit(6).toList());
        return "dashboard";
    }

    @GetMapping("/login")
    public String login(){return "login";}

    @GetMapping("/manage/{key}")
    public String list(@PathVariable String key,Model model){
        Module m=service.get(key);
        if(m==null) return "redirect:/";
        model.addAttribute("module",m);
        model.addAttribute("records",service.list(key));
        return "module-list";
    }

    @GetMapping("/manage/{key}/new")
    public String createForm(@PathVariable String key,Model model){
        Module m=service.get(key);
        if(m==null) return "redirect:/";
        model.addAttribute("module",m); model.addAttribute("record",Map.of()); model.addAttribute("editing",false);
        return "module-form";
    }

    @GetMapping("/manage/{key}/{id}/edit")
    public String editForm(@PathVariable String key,@PathVariable long id,Model model){
        Module m=service.get(key);
        if(m==null) return "redirect:/";
        model.addAttribute("module",m); model.addAttribute("record",service.find(key,id)); model.addAttribute("editing",true);
        return "module-form";
    }

    @PostMapping("/manage/{key}/save")
    public String save(@PathVariable String key,@RequestParam(required=false) Long id,
                       @RequestParam Map<String,String> params,RedirectAttributes ra){
        try{
            service.save(key,id,params);
            ra.addFlashAttribute("success","Record saved successfully.");
        }catch(Exception e){
            ra.addFlashAttribute("error",e.getMessage()==null?"Unable to save record.":e.getMessage());
            return "redirect:/manage/"+key+(id==null?"/new":"/"+id+"/edit");
        }
        return "redirect:/manage/"+key;
    }

    @PostMapping("/manage/{key}/{id}/delete")
    public String delete(@PathVariable String key,@PathVariable long id,RedirectAttributes ra){
        try{service.delete(key,id);ra.addFlashAttribute("success","Record deleted.");}
        catch(Exception e){ra.addFlashAttribute("error","Could not delete this record. Check whether another record depends on it.");}
        return "redirect:/manage/"+key;
    }
}
