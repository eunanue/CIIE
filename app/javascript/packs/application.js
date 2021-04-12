require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");

import '../stylesheets/application'
import 'bootstrap/dist/js/bootstrap';
import 'bootstrap-datepicker/dist/js/bootstrap-datepicker';


$( document ).on('turbolinks:load', function() {

    window.setTimeout(() => {
        window.setTimeout(() => {
            document.body.classList.remove('loading');
        }, 350);
    });

    $('form').on('click', '.remove_fields', function(event) {
        $(this).closest('.nested-item').hide();
        $(this).closest('.nested-item').children('input[type=hidden].destroy-hidden-field').val('1');
        event.preventDefault();
    });

    $('.simple-dynamic-form').on('click', '.add_fields', function(event) {
        let time = new Date().getTime();
        let regexp = new RegExp($(this).data('id'), 'g');
        let nested_anchor = $(this).prev('.nested-anchor');

        if($(nested_anchor).length)
        {
            $(nested_anchor).append($(this).data('fields').replace(regexp, time));
        }
        else
        {
            $(this).before($(this).data('fields').replace(regexp, time));
        }

        if($('.professor-search-group').length)
        {
            $('.search-professor-button').unbind('click', professor_search_service);
            $('.search-professor-button').on('click', professor_search_service);
        }

        event.preventDefault();
    });

    $('#delete-modal').on('show.bs.modal', function(event) {
        let modal = $(this);
        let button = $(event.relatedTarget);
        let id = button.data('id');
        let name = button.data('name');
        let controller_name = button.data('controller-name');
        let delete_button = modal.find('.delete-trigger');
        let message_container = modal.find('.modal-body .message');
        let cancel_button = modal.find('.cancel-button');

        message_container.html(`¿Estás seguro que deseas eliminar ${name}?`);

        delete_button.unbind('click');
        delete_button.on('click', function(event)
        {
            $.ajax({
                url: `/${controller_name}/${id}`,
                method: 'DELETE',
                success: function(data)
                {
                    message_container.html(data.message);
                    delete_button.hide();
                    cancel_button.html('Cerrar');
                }
            });
        });
    });

    $('#delete-modal').on('hidden.bs.modal', function(event) {
        location.reload();
    });

    $('.state-select').hide();
    $('.country-select').on('change', function(event){
        let country = $(this).children('option:selected').text();

        if(country === 'Mexico'){
            $('.state-select').show();
        }
        else {
            $('.state-select').hide();
        }
    });

    $('.filter-by-generation-button').on('click', function(event){
        event.preventDefault();
        const selected_generation = $('.filter-by-generation-select option:selected').text();
        console.log(selected_generation);
        window.location.href = `http://${window.location.host}/papers?generation=${selected_generation}`
    });

    $('.score-field').on('change', function(event){
        updateScore();
    });

    function updateScore(){
        let scoreSum = 0;

        $('.score-field').each(function(index, element){
            let score = Number.parseInt($(element).val());

            if(!isNaN(score)) {
                scoreSum += score;
            }
        });

        $('.point-sum').text(scoreSum);
    }
    updateScore();

    function refresh_user_fields()
    {
        $('.country-select-paper').each((index, value) => {
            let user_container = $(value).closest('.user-paper-container');
            let country = $(value).children('option:selected').text();

            if(country === 'Mexico'){
                $(user_container).find('.state-select-paper').show();
            }
            else{
                $(user_container).find('.state-select-paper').hide();
            }
        });

        $('.country-select-paper').unbind('change');
        $('.country-select-paper').on('change', function(event){
            let user_container = $(event.target).closest('.user-paper-container');
            let country = $(event.target).children('option:selected').text();

            if(country === 'Mexico'){
                $(user_container).find('.state-select-paper').show();
            }
            else {
                $(user_container).find('.state-select-paper').hide();
            }
        });

        $('.institution-select-paper').each((index, value) => {
            let user_container = $(value).closest('.user-paper-container');
            let institution_option = $(value).children('option:selected').text();
            let institution_extra_fields = user_container.find('.paper_extra_institution_fields');
            let code_field = user_container.find('.paper_code_field');

            if(institution_option === 'Otra' || institution_option === 'Other'){
                $(institution_extra_fields).show();
            }
            else{
                $(institution_extra_fields).hide();
            }

            if(institution_option === 'Tecnológico de Monterrey' || institution_option === 'Tecmilenio'){
                $(code_field).show();
                console.log($(code_field).is(':hidden'))
            }
            else
            {
                $(code_field).hide();
            }
        });

        $('.institution-select-paper').unbind('change');
        $('.institution-select-paper').on('change', (event) => {
            let user_container = $(event.target).closest('.user-paper-container');
            let institution_option = $(event.target).children('option:selected').text();
            let institution_extra_fields = user_container.find('.paper_extra_institution_fields');
            let code_field = user_container.find('.paper_code_field');

            if(institution_option === 'Otra' || institution_option === 'Other'){
                $(institution_extra_fields).show();
            }
            else{
                $(institution_extra_fields).hide();
            }

            if(institution_option === 'Tecnológico de Monterrey' || institution_option === 'Tecmilenio'){
                $(code_field).show();
            }
            else
            {
                $(code_field).hide();
            }
        });
    }
    refresh_user_fields();

    $('.add-collaborator-button').on('click', function(event){
        event.preventDefault();

        let add_collaborator_link = $('.new-collaborator-field-link');
        let user_email = $('.search-by-email-field').val();
        let time = new Date().getTime();
        let regexp = new RegExp($(add_collaborator_link).data('id'), 'g');

        $('.nested-anchor').append($(add_collaborator_link).data('fields').replace(regexp, time));

        let last_nested_user = $('.nested-anchor .nested-item:last-child');

        last_nested_user.find('.email-field').val(user_email);

        $('.search-by-email-field').val('');

        $.ajax({url: '/users/search',
            data: {email: user_email},
            type: 'get',
            success: function(data) {
                if (data.error) {
                    last_nested_user.find('.needs-registration-professor').removeClass('d-none');
                }
                else {
                    last_nested_user.find('.found-professor').removeClass('d-none');
                    last_nested_user.find('.id_field').val(data.id);
                    last_nested_user.find('.names-field').val(data.names);
                    last_nested_user.find('.last-names-field').val(data.last_names);
                    last_nested_user.find('.phone-field').val(data.phone);
                }
            }});

        refresh_user_fields();
    });

    function update_collaborator_section_title(){
        let contribution_type_text = $('.contribution_type_select').children('option:selected').text().toLowerCase();
        let locale_span = $('.locale-span').text();

        if (contribution_type_text === 'mesa de networking'){
            let text = locale_span === 'eng' ? 'Collaborators' : 'Colaboradores';
            $('.collaborator_section_title').text(text)
        } else if (contribution_type_text === 'presentación de libro' || contribution_type_text === 'book presentation'){
            let text = locale_span === 'eng' ? 'Commentators' : 'Comentaristas';
            $('.collaborator_section_title').text(text)
        } else if (contribution_type_text === 'panel'){
            let text = locale_span === 'eng' ? 'Panelists' : 'Panelistas';
            $('.collaborator_section_title').text(text)
        } else if(contribution_type_text === 'ponencia de innovación' ||
            contribution_type_text === 'ponencia de investigación' ||
            contribution_type_text === 'innovation paper' ||
            contribution_type_text === 'research paper'){
            let text = locale_span === 'eng' ? 'Coauthors' : 'Coautores';
            $('.collaborator_section_title').text(text)
        } else {
            let text = locale_span === 'eng' ? 'Collaborators' : 'Colaboradores';
            $('.collaborator_section_title').text(text);
        }
    }

    function update_template_url(){
        let contribution_type_id = $('.contribution_type_select').not(':disabled').children('option:selected').val();
        let locale_span = $('.locale-span').text();

        $.ajax({url: '/contribution_type/get_url',
            data: {contribution_type_id: contribution_type_id},
            type: 'get',
            success: function(data) {
                if (data.error) {
                    console.log('Contribution type not found');
                }
                else {
                    let url = locale_span === 'eng' ? data.en_url : data.url;

                    $('.download-template-button').attr('href', url)
                }
            }});

        update_collaborator_section_title();
    }
    $('.contribution_type_select').on('change', update_template_url);
    update_collaborator_section_title();
    if($('.contribution_type_select').length) {
        update_template_url();
    }

    function update_institution_fields(event){
        let option_text = $('.institution_selector option:selected').text();

        if(option_text === 'Otra' || option_text === 'Other' || option_text === 'Escuelas vinculadas' || option_text === 'Linked Schools'){
            $('.extra_institution_fields').show();
        }
        else{
            $('.extra_institution_fields').hide();
        }

        if(option_text === 'Tecnológico de Monterrey' || option_text === 'Tecmilenio'){
            $('.code_field').show();
        }
        else
        {
            $('.code_field').hide();
        }
    }
    $('.institution_selector').on('change', update_institution_fields);
    update_institution_fields();

    function update_academic_level_fields(event){
        let option_text = $('.academic_level_selector option:selected').text();

        if(option_text === 'Otro' || option_text === 'Other'){
            $('.extra_academic_level_fields').show();
        }
        else{
            $('.extra_academic_level_fields').hide();
        }
    }
    $('.academic_level_selector').on('change', update_academic_level_fields);
    update_academic_level_fields();

    function update_academic_area_fields(event){
        let option_text = $('.academic_area_selector option:selected').text();

        if(option_text === 'Otro' || option_text === 'Other'){
            $('.extra_academic_area_fields').show();
        }
        else{
            $('.extra_academic_area_fields').hide();
        }
    }
    $('.academic_area_selector').on('change', update_academic_area_fields);
    update_academic_area_fields();

    function update_subtopic_options(event){
        let topic_id = $('.topic-selector option:selected').val();
        let topic_name = $('.topic-selector option:selected').text();

        $('.contribution_type_select').hide();
        $('.contribution_type_select').prop('disabled', 'disabled');
        if(topic_name === 'Emprendimiento Edtech' || topic_name === 'Edtech Entrepreneurship'){
            $('.edtech-contributions').show();
            $('.edtech-contributions').prop('disabled', false);
        }
        else {
            $('.none-edtech-contributions').show();
            $('.none-edtech-contributions').prop('disabled', false);
        }

        $('.no_topic_selected_warning').hide();

        $('.subtopic-selector').hide();
        $('.subtopic-selector').prop('disabled', 'disabled');

        $(`.subtopic-${topic_id}-selector`).show();
        $(`.subtopic-${topic_id}-selector`).prop('disabled', false);

        if(topic_id === ''){
            $('.no_topic_selected_warning').show();
        }
    }
    $('.topic-selector').on('change', update_subtopic_options);
    update_subtopic_options();

    function update_subtopic_selector(event){
        $('.subtopic_other_fields').hide();

        $('.subtopic-selector').each(function(index, element) {
            if (!$(this).prop('disabled')) {
                let option_id = $(this).children('option:selected').val();

                if (option_id !== '') {
                    let option_text = $(this).children('option:selected').text();

                    if (option_text === 'Otro' ||
                        option_text === 'Other' ||
                        option_text === 'Otros (Casos clínicos, herramientas para el desarrollo del juicio médico)') {
                        $('.subtopic_other_fields').show();
                    }
                    else {
                        $('.subtopic_other_fields').hide();
                    }
                }
            }
        });
    }

    $('.subtopic-selector').on('change', update_subtopic_selector);
    update_subtopic_selector(null);
});